<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- Ensure proper rendering and touch zooming on mobile devices -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Orders - Eco Gardening Supplies</title>
    <!-- Include Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Placed Orders</h2>
        <!-- Table to display orders -->
        <table class="table table-bordered">
            <thead>
                <tr>
                    <!-- Table headers -->
                    <th>Order ID</th>
                    <th>Username</th>
                    <th>Total Weight (kg)</th>
                    <th>Shipping Cost (ZAR)</th>
                    <th>Total Cost (ZAR)</th>
                    <th>Order Date</th>
                    <th>Items</th>
                </tr>
            </thead>
            <tbody>
                <!-- Loop through each order -->
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <!-- Display order details -->
                        <td>${order.id}</td>
                        <td>${order.username}</td>
                        <td>
                            <!-- Format total weight as number with two decimal places -->
                            <fmt:formatNumber value="${order.totalWeight}" type="number" pattern="#,##0.00" />
                        </td>
                        <td>
                            <!-- Format shipping cost as number with two decimal places -->
                            <fmt:formatNumber value="${order.shippingCost}" type="number" pattern="#,##0.00" />
                        </td>
                        <td>
                            <!-- Format total cost as number with two decimal places -->
                            <fmt:formatNumber value="${order.totalCost}" type="number" pattern="#,##0.00" />
                        </td>
                        <td>
                            <!-- Format order date -->
                            <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                        </td>
                        <td>
                            <!-- List of items in the order -->
                            <ul>
                                <!-- Loop through each item in the order -->
                                <c:forEach var="item" items="${order.items}">
                                    <li>
                                        <!-- Display item details -->
                                        ${item.productName}: ZAR 
                                        <!-- Format product price as number with two decimal places -->
                                        <fmt:formatNumber value="${item.productPrice}" type="number" pattern="#,##0.00" /> 
                                        (${item.productWeight} kg)
                                    </li>
                                </c:forEach>
                            </ul>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Include Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
