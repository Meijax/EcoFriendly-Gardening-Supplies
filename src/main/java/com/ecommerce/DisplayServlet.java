package com.ecommerce;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import org.json.JSONArray;
import org.json.JSONObject;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;

@WebServlet("/DisplayServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class DisplayServlet extends HttpServlet {
    private final String uploadDirectory = "C:/Users/Meyer/Documents/NetBeansProjects/EcoFriendlyWebsite/src/main/webapp/images";
    private final String relativePath = "images"; // Relative path to be stored in database
    
    // Method to extract file name from the file part
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return "";
    }
    
    // Method to save file to the specified directory and return the relative path
    private String saveFile(Part filePart) throws IOException {
        String fileName = getFileName(filePart);
        if (!fileName.isEmpty()) {
            Path uploadPath = Paths.get(uploadDirectory, fileName);
            // Check if the file already exists and generate a unique filename if it does
            if (Files.exists(uploadPath)) {
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                uploadPath = Paths.get(uploadDirectory, uniqueFileName);
            }
            Files.copy(filePart.getInputStream(), uploadPath);
            return Paths.get(relativePath, uploadPath.getFileName().toString()).toString(); // Return relative path
        }
        return null;
    }
    
    // Method to delete a file from the server
    private void deleteFile(String filePath) {
        try {
            Path absolutePath = Paths.get(uploadDirectory, filePath);
            Files.deleteIfExists(absolutePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            loadProducts(request); // Load products if no specific action is provided
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession();
            session.invalidate(); // Invalidate the session to logout
            response.sendRedirect("login.jsp");
        } else if ("profile".equals(action)) {
            HttpSession session = request.getSession();
            String username = (String) session.getAttribute("username");
            if (username != null) {
                response.sendRedirect("profile.jsp");
            } else {
                response.sendRedirect("login.jsp");
            }
        } else if ("blogs".equals(action)) {
            loadBlogs(request); // Load blogs and forward to blogs.jsp
            request.getRequestDispatcher("blogs.jsp").forward(request, response);
        } else if ("cart".equals(action)) {
            loadCart(request, response); // Load cart and forward to cart.jsp
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } else if ("paymentDetails".equals(action)) {
            HttpSession session = request.getSession();
            calculateCartDetails(session); // Calculate cart details before forwarding
            request.getRequestDispatcher("paymentdetails.jsp").forward(request, response);
        } else if ("adminDashboard".equals(action)) {
            loadProducts(request); // Load products for admin dashboard
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        } else if ("viewOrders".equals(action)) {
            loadOrders(request); // Load orders and forward to adminOrders.jsp
            request.getRequestDispatcher("adminOrders.jsp").forward(request, response);
        } else if ("addProduct".equals(action)) {
            loadAllCategories(request); // Load categories and products for adding a product
            loadAllProductsForAdmin(request);
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);
        } else if ("modifyProduct".equals(action)) {
            loadAllProductsForAdmin(request); // Load products for modifying a product
            request.getRequestDispatcher("modifyProduct.jsp").forward(request, response);
        } else if ("removeProduct".equals(action)) {
            loadAllProductsForAdmin(request); // Load products for removing a product
            request.getRequestDispatcher("removeProduct.jsp").forward(request, response);
        } else if ("viewContactMessages".equals(action)) {
            loadContactMessages(request); // Load contact messages and forward to viewContactMessages.jsp
            request.getRequestDispatcher("viewContactMessages.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "register":
                handleRegistration(request, response); // Handle user registration
                break;
            case "login":
                handleLogin(request, response); // Handle user login
                break;
            case "add":
            case "remove":
                handleCart(request, response, action); // Handle adding/removing items from cart
                break;
            case "updateProfile":
                handleProfileUpdate(request, response); // Handle user profile update
                break;
            case "contact":
                handleContact(request, response); // Handle contact form submission
                break;
            case "placeOrder":
                handlePlaceOrder(request, response); // Handle placing an order
                break;
            case "addProduct":
                handleAddProduct(request, response); // Handle adding a new product
                break;
            case "modifyProduct":
                handleModifyProduct(request, response); // Handle modifying an existing product
                break;
            case "removeProduct":
                handleRemoveProduct(request, response); // Handle removing a product
                break;
            case "addCategory":
                handleAddCategory(request, response); // Handle adding a new category
                break;
            case "respondMessage":
                handleRespondMessage(request, response); // Handle responding to a contact message
                break;
            case "addBlogPost":
                handleAddBlogPost(request, response); // Handle adding a new blog post
                break;
            default:
                response.sendRedirect("index.jsp"); // Redirect to home page if action is not recognized
                break;
        }
    }

    // Method to load products and set as request attribute
    private void loadProducts(HttpServletRequest request) {
        Map<String, List<String[]>> categorizedProducts = new HashMap<>();
        List<String[]> allProducts = new ArrayList<>();
        String query = "SELECT p.id, p.name, p.price, p.image, p.description, p.weight, c.name as category FROM products p LEFT JOIN categories c ON p.category_id = c.id";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                String[] product = new String[6];
                product[0] = String.valueOf(resultSet.getInt("id"));
                product[1] = resultSet.getString("name");
                product[2] = String.valueOf(resultSet.getDouble("price"));
                product[3] = resultSet.getString("image");
                product[4] = resultSet.getString("description");
                product[5] = String.valueOf(resultSet.getDouble("weight"));
                String category = resultSet.getString("category");

                categorizedProducts.computeIfAbsent(category, k -> new ArrayList<>()).add(product);
                allProducts.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("categorizedProducts", categorizedProducts);
        request.setAttribute("allProducts", allProducts);
    }
    
    // Method to load all products for admin view and set as request attribute
    private void loadAllProductsForAdmin(HttpServletRequest request) {
        List<String[]> allProducts = new ArrayList<>();
        String query = "SELECT p.id, p.name, p.price, p.image, p.description, p.weight, c.name as category FROM products p LEFT JOIN categories c ON p.category_id = c.id";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                String[] product = new String[7];
                product[0] = String.valueOf(resultSet.getInt("id"));
                product[1] = resultSet.getString("name");
                product[2] = String.valueOf(resultSet.getDouble("price"));
                product[3] = resultSet.getString("image");
                product[4] = resultSet.getString("description");
                product[5] = String.valueOf(resultSet.getDouble("weight"));
                product[6] = resultSet.getString("category");

                allProducts.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("allProducts", allProducts);
    }

    // Method to load all categories and set as request attribute
    private void loadAllCategories(HttpServletRequest request) {
        List<String[]> allCategories = new ArrayList<>();
        String query = "SELECT id, name FROM categories";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                String[] category = new String[2];
                category[0] = String.valueOf(resultSet.getInt("id"));
                category[1] = resultSet.getString("name");
                allCategories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("allCategories", allCategories);
    }

    // Method to handle user registration
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        try (Connection connection = DBConnection.getConnection()) {
            // Check if the username or email already exists
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
            try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                checkStmt.setString(2, email);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Username or email already exists
                        request.setAttribute("errorMessage", "Username or email already exists. Please choose another.");
                        request.setAttribute("username", username);
                        request.setAttribute("email", email);
                        request.getRequestDispatcher("registration.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Insert the new user
            String sql = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, username);
                statement.setString(2, password); // Ideally, hash the password before storing it
                statement.setString(3, email);

                int result = statement.executeUpdate();
                if (result > 0) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("email", email); // Set email in session
                    response.sendRedirect("login.jsp");
                } else {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.setAttribute("username", username);
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("registration.jsp").forward(request, response);
                }
            }
        } catch (SQLException | ServletException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("registration.jsp").forward(request, response);
        }
    }

    // Method to handle user login
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(username) && "admin".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", "admin");
            response.sendRedirect("adminDashboard.jsp");
        } else {
            try (Connection connection = DBConnection.getConnection()) {
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setString(1, username);
                    statement.setString(2, password);

                    try (ResultSet resultSet = statement.executeQuery()) {
                        if (resultSet.next()) {
                            HttpSession session = request.getSession();
                            session.setAttribute("username", username);
                            session.setAttribute("email", resultSet.getString("email")); // Set email in session
                            response.sendRedirect(request.getContextPath() + "/");
                        } else {
                            request.setAttribute("errorMessage", "Invalid username or password.");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }
                    }
                }
            } catch (SQLException | ServletException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "An error occurred. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }

    // Method to handle adding or removing items from the cart
    private void handleCart(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        String productId = request.getParameter("productId");
        HttpSession session = request.getSession();
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        if ("add".equals(action)) {
            try (Connection connection = DBConnection.getConnection()) {
                String query = "SELECT id, name, price, weight FROM products WHERE id = ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                    preparedStatement.setString(1, productId);
                    ResultSet resultSet = preparedStatement.executeQuery();
                    if (resultSet.next()) {
                        Map<String, Object> product = new HashMap<>();
                        product.put("id", resultSet.getInt("id"));
                        product.put("name", resultSet.getString("name"));
                        product.put("price", resultSet.getDouble("price"));
                        product.put("weight", resultSet.getDouble("weight"));
                        cart.add(product);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if ("remove".equals(action)) {
            cart.removeIf(product -> product.get("id").equals(Integer.parseInt(productId)));
        }

        double totalWeight = cart.stream().mapToDouble(p -> (Double) p.get("weight")).sum();
        session.setAttribute("cart", cart);
        session.setAttribute("totalWeight", totalWeight);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("success", true);
        out.print(jsonResponse.toString());
        out.close();
    }

    // Method to load cart items and set as request attribute
    private void loadCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        JSONArray cartProducts = new JSONArray();

        if (cart != null && !cart.isEmpty()) {
            try (Connection connection = DBConnection.getConnection()) {
                StringBuilder query = new StringBuilder("SELECT * FROM products WHERE id IN (");
                for (int i = 0; i < cart.size(); i++) {
                    query.append("?");
                    if (i < cart.size() - 1) {
                        query.append(",");
                    }
                }
                query.append(")");
                try (PreparedStatement preparedStatement = connection.prepareStatement(query.toString())) {
                    for (int i = 0; i < cart.size(); i++) {
                        preparedStatement.setInt(i + 1, (Integer) cart.get(i).get("id"));
                    }
                    ResultSet resultSet = preparedStatement.executeQuery();
                    while (resultSet.next()) {
                        JSONObject product = new JSONObject();
                        product.put("id", resultSet.getInt("id"));
                        product.put("name", resultSet.getString("name"));
                        product.put("price", resultSet.getDouble("price"));
                        cartProducts.put(product);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(cartProducts.toString());
        out.close();
    }

    // Method to calculate cart details and set as session attributes
    private void calculateCartDetails(HttpSession session) {
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        double totalWeight = 0;
        double cartTotal = 0;

        if (cart != null) {
            for (Map<String, Object> product : cart) {
                double weight = (double) product.get("weight");
                double price = (double) product.get("price");
                totalWeight += weight;
                cartTotal += price;
            }
        }

        double weightCost = totalWeight * 10; // Base cost for weight is 10 ZAR per kg
        double grandTotal = cartTotal + weightCost;

        session.setAttribute("totalWeight", totalWeight);
        session.setAttribute("weightCost", weightCost);
        session.setAttribute("grandTotal", grandTotal);
    }

    // Method to handle placing an order
    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        calculateCartDetails(session); // Calculate cart details before proceeding
        
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        double totalWeight = (double) session.getAttribute("totalWeight");
        double shippingCost = (double) session.getAttribute("weightCost");
        double totalCost = (double) session.getAttribute("grandTotal");

        request.setAttribute("totalWeight", session.getAttribute("totalWeight"));
        request.setAttribute("weightCost", session.getAttribute("weightCost"));
        request.setAttribute("grandTotal", session.getAttribute("grandTotal"));
        
        request.getRequestDispatcher("paymentdetails.jsp").forward(request, response);

        String cardNumber = request.getParameter("cardNumber");
        String expiryDate = request.getParameter("expiryDate");
        String cvc = request.getParameter("cvc");
        String address = request.getParameter("address");
        String address2 = request.getParameter("address2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zip = request.getParameter("zip");

        int orderId = 0;

        try (Connection connection = DBConnection.getConnection()) {
            // Get user ID
            String userQuery = "SELECT id FROM users WHERE username = ?";
            int userId = 0;
            try (PreparedStatement userStmt = connection.prepareStatement(userQuery)) {
                userStmt.setString(1, username);
                try (ResultSet userRs = userStmt.executeQuery()) {
                    if (userRs.next()) {
                        userId = userRs.getInt("id");
                    }
                }
            }

            // Insert into orders table
            String orderQuery = "INSERT INTO orders (user_id, total_weight, shipping_cost, total_cost, card_number, expiry_date, cvc, address, address2, city, state, zip) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement orderStmt = connection.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, userId);
                orderStmt.setDouble(2, totalWeight);
                orderStmt.setDouble(3, shippingCost);
                orderStmt.setDouble(4, totalCost);
                orderStmt.setString(5, cardNumber);
                orderStmt.setString(6, expiryDate);
                orderStmt.setString(7, cvc);
                orderStmt.setString(8, address);
                orderStmt.setString(9, address2);
                orderStmt.setString(10, city);
                orderStmt.setString(11, state);
                orderStmt.setString(12, zip);
                orderStmt.executeUpdate();

                ResultSet generatedKeys = orderStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);

                    // Insert into order_items table
                    String itemQuery = "INSERT INTO order_items (order_id, product_id, product_name, product_price, product_weight) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement itemStmt = connection.prepareStatement(itemQuery)) {
                        for (Map<String, Object> product : cart) {
                            itemStmt.setInt(1, orderId);
                            itemStmt.setInt(2, (int) product.get("id"));
                            itemStmt.setString(3, (String) product.get("name"));
                            itemStmt.setDouble(4, (double) product.get("price"));
                            itemStmt.setDouble(5, (double) product.get("weight"));
                            itemStmt.addBatch();
                        }
                        itemStmt.executeBatch();
                    }
                }
            }

            // Send confirmation email
            String email = (String) session.getAttribute("userEmail");
            if (email != null) {
                String subject = "Order Confirmation - Eco Gardening Supplies";
                String content = "Your order was successfully placed. Your order ID is " + orderId + ". Thank you for shopping with us!";
                EmailUtil.sendEmail(email, subject, content);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to place order. Please try again.");
            return;
        }

        // Clear cart and related session attributes
        session.removeAttribute("cart");
        session.removeAttribute("totalWeight");
        session.removeAttribute("weightCost");
        session.removeAttribute("cartTotal");
        session.removeAttribute("grandTotal");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": true}");
        out.flush();
    }

    // Method to handle updating user profile
    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "UPDATE users SET first_name = ?, last_name = ?, email = ?, address = ?, phone = ? WHERE username = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, firstName);
                statement.setString(2, lastName);
                statement.setString(3, email);
                statement.setString(4, address);
                statement.setString(5, phone);
                statement.setString(6, username);

                int result = statement.executeUpdate();
                if (result > 0) {
                    request.setAttribute("successMessage", "Profile updated successfully.");
                } else {
                    request.setAttribute("errorMessage", "Update failed. Please try again.");
                }
                response.sendRedirect(request.getContextPath() + "/"); // Redirect to context root after profile update
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
    
    // Method to handle contact form submission
    private void handleContact(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "INSERT INTO contact_messages (name, email, message) VALUES (?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, name);
                statement.setString(2, email);
                statement.setString(3, message);

                int result = statement.executeUpdate();
                if (result > 0) {
                    request.setAttribute("messageReceived", true);
                } else {
                    request.setAttribute("messageReceived", false);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("messageReceived", false);
        }

        request.getRequestDispatcher("index.jsp#contact").forward(request, response);
    }
    
    // Method to load contact messages and set as request attribute
    private void loadContactMessages(HttpServletRequest request) {
        List<Map<String, String>> contactMessages = new ArrayList<>();
        String query = "SELECT * FROM contact_messages ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                Map<String, String> message = new HashMap<>();
                message.put("id", String.valueOf(resultSet.getInt("id")));
                message.put("name", resultSet.getString("name"));
                message.put("email", resultSet.getString("email"));
                message.put("message", resultSet.getString("message"));
                contactMessages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("contactMessages", contactMessages);
    }

    // Method to handle responding to a contact message
    private void handleRespondMessage(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String messageId = request.getParameter("messageId");
        String responseText = request.getParameter("response");

        try (Connection connection = DBConnection.getConnection()) {
            String query = "SELECT email FROM contact_messages WHERE id = ?";
            String recipientEmail = null;
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, messageId);
                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        recipientEmail = resultSet.getString("email");
                    }
                }
            }

            if (recipientEmail != null) {
                // Send the email response
                EmailUtil.sendEmail(recipientEmail, "Response to your inquiry", responseText);

                // Delete the message after responding
                String deleteQuery = "DELETE FROM contact_messages WHERE id = ?";
                try (PreparedStatement deleteStatement = connection.prepareStatement(deleteQuery)) {
                    deleteStatement.setString(1, messageId);
                    deleteStatement.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        loadContactMessages(request);
        request.getRequestDispatcher("viewContactMessages.jsp").forward(request, response);
    }

    // Method to handle adding a new product
    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String categoryId = request.getParameter("category");
        String weight = request.getParameter("weight");
        Part filePart = request.getPart("image");
        String imagePath = saveFile(filePart);

        try (Connection connection = DBConnection.getConnection()) {
            String query = "INSERT INTO products (name, description, price, category_id, weight, image) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setString(1, name);
                statement.setString(2, description);
                statement.setString(3, price);
                statement.setString(4, categoryId);
                statement.setString(5, weight);
                statement.setString(6, imagePath);
                statement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to add product.");
        }
        loadAllProductsForAdmin(request);
        loadAllCategories(request);
        request.getRequestDispatcher("addProduct.jsp").forward(request, response);
    }

    // Method to handle modifying an existing product
    private void handleModifyProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String categoryId = request.getParameter("category");
        String weight = request.getParameter("weight");
        Part filePart = request.getPart("image");
        String imagePath = saveFile(filePart);

        try (Connection connection = DBConnection.getConnection()) {
            String query = "UPDATE products SET name=?, description=?, price=?, category_id=?, weight=?"
                         + (imagePath != null ? ", image=?" : "") + " WHERE id=?";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setString(1, name);
                statement.setString(2, description);
                statement.setString(3, price);
                statement.setString(4, categoryId);
                statement.setString(5, weight);
                int parameterIndex = 6;
                if (imagePath != null) {
                    statement.setString(parameterIndex++, imagePath);
                }
                statement.setString(parameterIndex, id);
                statement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to modify product.");
        }
        loadAllProductsForAdmin(request);
        loadAllCategories(request);
        request.getRequestDispatcher("modifyProduct.jsp").forward(request, response);
    }

    // Method to handle removing a product
    private void handleRemoveProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String id = request.getParameter("id");

        try (Connection connection = DBConnection.getConnection()) {
            // Get the image path before deleting the product
            String queryGetImage = "SELECT image FROM products WHERE id=?";
            String imagePath = null;
            try (PreparedStatement statementGetImage = connection.prepareStatement(queryGetImage)) {
                statementGetImage.setString(1, id);
                try (ResultSet resultSet = statementGetImage.executeQuery()) {
                    if (resultSet.next()) {
                        imagePath = resultSet.getString("image");
                    }
                }
            }

            // Delete the product
            String queryDeleteProduct = "DELETE FROM products WHERE id=?";
            try (PreparedStatement statementDeleteProduct = connection.prepareStatement(queryDeleteProduct)) {
                statementDeleteProduct.setString(1, id);
                statementDeleteProduct.executeUpdate();
            }

            // Delete the image file if it exists
            if (imagePath != null) {
                deleteFile(imagePath); // Pass the relative path to the deleteFile method
            }

            loadAllProductsForAdmin(request); // Reload the products to update the table
            request.getRequestDispatcher("removeProduct.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to remove product.");
            request.getRequestDispatcher("removeProduct.jsp").forward(request, response);
        }
    }

    // Method to handle adding a new category
    private void handleAddCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");

        try (Connection connection = DBConnection.getConnection()) {
            // Check if the category already exists
            String checkQuery = "SELECT COUNT(*) FROM categories WHERE name = ?";
            try (PreparedStatement checkStmt = connection.prepareStatement(checkQuery)) {
                checkStmt.setString(1, category);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("message", "Category already exists.");
                        request.getRequestDispatcher("addCategory.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Insert the new category
            String insertQuery = "INSERT INTO categories (name) VALUES (?)";
            try (PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {
                insertStmt.setString(1, category);
                int result = insertStmt.executeUpdate();
                if (result > 0) {
                    request.setAttribute("message", "Category added successfully.");
                } else {
                    request.setAttribute("message", "Failed to add category. Please try again.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred. Please try again.");
        }
        request.getRequestDispatcher("addCategory.jsp").forward(request, response);
    }
    
    // Method to load blogs and set as request attribute
    private void loadBlogs(HttpServletRequest request) {
        List<Blog> blogs = new ArrayList<>();
        String query = "SELECT * FROM blogs ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                Blog blog = new Blog();
                blog.setId(resultSet.getInt("id"));
                blog.setTitle(resultSet.getString("title"));
                blog.setContent(resultSet.getString("content"));
                blog.setAuthor(resultSet.getString("author"));
                blog.setCreatedAt(resultSet.getTimestamp("created_at"));
                blog.setLink(resultSet.getString("link"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("blogs", blogs);
    }

    // Method to handle adding a new blog post
    private void handleAddBlogPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String author = request.getParameter("author");
        String link = request.getParameter("link");

        try (Connection connection = DBConnection.getConnection()) {
            String query = "INSERT INTO blogs (title, content, author, link) VALUES (?, ?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setString(1, title);
                statement.setString(2, content);
                statement.setString(3, author);
                if (link == null || link.isEmpty()) {
                    statement.setNull(4, Types.VARCHAR);
                } else {
                    statement.setString(4, link);
                }
                statement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to add blog post.");
        }
        request.getRequestDispatcher("addBlogPost.jsp").forward(request, response);
    }
    
    // Method to load orders and set as request attribute
    private void loadOrders(HttpServletRequest request) {
        List<Map<String, Object>> orders = new ArrayList<>();
        String query = "SELECT o.*, u.username FROM orders o LEFT JOIN users u ON o.user_id = u.id ORDER BY o.order_date DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("id", resultSet.getInt("id"));
                order.put("username", resultSet.getString("username"));
                order.put("totalWeight", resultSet.getDouble("total_weight"));
                order.put("shippingCost", resultSet.getDouble("shipping_cost"));
                order.put("totalCost", resultSet.getDouble("total_cost"));
                order.put("orderDate", resultSet.getTimestamp("order_date"));

                List<Map<String, Object>> orderItems = new ArrayList<>();
                String itemQuery = "SELECT * FROM order_items WHERE order_id = ?";
                try (PreparedStatement itemStmt = connection.prepareStatement(itemQuery)) {
                    itemStmt.setInt(1, resultSet.getInt("id"));
                    try (ResultSet itemRs = itemStmt.executeQuery()) {
                        while (itemRs.next()) {
                            Map<String, Object> item = new HashMap<>();
                            item.put("productName", itemRs.getString("product_name"));
                            item.put("productPrice", itemRs.getDouble("product_price"));
                            item.put("productWeight", itemRs.getDouble("product_weight"));
                            orderItems.add(item);
                        }
                    }
                }
                order.put("items", orderItems);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("orders", orders);
    }
}
