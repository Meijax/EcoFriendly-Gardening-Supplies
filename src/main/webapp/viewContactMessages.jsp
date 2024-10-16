<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null || !user.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> messages = (List<Map<String, String>>) request.getAttribute("contactMessages");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Contact Messages</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <a href="adminDashboard.jsp" class="btn btn-secondary mb-3">Back</a>
        <h1 class="text-center">Contact Messages</h1>
        <table class="table table-striped mt-3">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Message</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (messages != null) {
                        for (Map<String, String> message : messages) {
                %>
                <tr>
                    <td><%= message.get("id") %></td>
                    <td><%= message.get("name") %></td>
                    <td><%= message.get("email") %></td>
                    <td><%= message.get("message") %></td>
                    <td>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#respondModal<%= message.get("id") %>">Respond</button>

                        <!-- Modal -->
                        <div class="modal fade" id="respondModal<%= message.get("id") %>" tabindex="-1" aria-labelledby="respondModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="respondModalLabel">Respond to Message</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form action="DisplayServlet" method="post">
                                            <input type="hidden" name="action" value="respondMessage">
                                            <input type="hidden" name="messageId" value="<%= message.get("id") %>">
                                            <div class="mb-3">
                                                <label for="response" class="form-label">Your Response</label>
                                                <textarea class="form-control" id="response" name="response" rows="3" required></textarea>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Send Response</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
