package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.tools.Tool;

import kgraph.ToJson;
import net.sf.json.JSONObject;

/**
 * Servlet implementation class SearchController
 */
public class DisplayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public DisplayServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //这句话可以解决从jsp页面接受到中文乱码问题
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html; charset=utf-8");
        String keyword = request.getParameter("keyword");
        System.out.println(keyword);
        JSONObject json = ToJson.getJson(keyword); //返回查询结果
        System.out.println(json);
        PrintWriter out = response.getWriter();
        out.print(json);
 
    }

}
