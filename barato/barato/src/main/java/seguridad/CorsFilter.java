/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package seguridad;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

/**
 * @author andresrobaneski
 */
public class CorsFilter extends OncePerRequestFilter {
    //String origin = "https://baratoapp.co";
    String origin = "*";

    String key = "Prlx+q?Wov8K1%o+bnn%p=Pog+d9GpLK?2pc2znx_xk1=dddmT4X+VZh1zk9yY*BxDI#=D1X?!?RNyuc!L#s^#go47Mj!FCFy%&otu44cMYlQP";
    String user = "baratoUser";
    String passuser = "gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+";

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String req = "";
        if (request.getRequestURI().length() >= 22)
            req = request.getRequestURI().substring(0, 22);

        if (req.equals("/barato/getWebScraping") == false)
        response.addHeader("Access-Control-Allow-Origin", origin);
        else
            response.addHeader("Access-Control-Allow-Origin", "*");

        response.addHeader("Content-Type", "application/json; charset=utf-8");

        if (request.getHeader("Access-Control-Request-Method") != null
                && "OPTIONS".equals(request.getMethod())) {
            // CORS "pre-flight" request
            response.addHeader("Access-Control-Allow-Credentials", "true");
            response.addHeader("Access-Control-Allow-Methods",
                    "GET, POST, PUT, DELETE");
            response.addHeader("Access-Control-Allow-Headers",
                    "X-Requested-With,Origin,Content-Type, Accept,OPTIONS,Authorization,Token,UserEmail");
            filterChain.doFilter(request, response);
        } else {


            final String authorization = request.getHeader("Authorization");
            if (authorization != null && authorization.toLowerCase().startsWith("basic")) {
                // Authorization: Basic base64credentials
                String base64Credentials = authorization.substring("Basic".length()).trim();
                byte[] credDecoded = Base64.getDecoder().decode(base64Credentials);
                String credentials = new String(credDecoded, StandardCharsets.UTF_8);
                // credentials = username:password
                final String[] values = credentials.split(":", 2);
                String uss = values[0];
                String pass = values[1];

                if ((uss.equals(user)) && (pass.equals(passuser))) {
                    response.addHeader("Access-Control-Allow-Credentials", "true");



                    if (req.equals("/barato/getWebScraping") == false) {


                        String token = request.getHeader("Token");
                        String UserEmail = request.getHeader("UserEmail");

                        if ((token != null) && (UserEmail != null)) {

                            String tokenarmado = user + "@@@" + UserEmail + "@@@" + pass + "@@@" + key;
                            byte[] tokdDecoded = Base64.getDecoder().decode(token);
                            String tokendec = new String(tokdDecoded, StandardCharsets.UTF_8);
                            if (tokendec.equals(tokenarmado)) {
                                filterChain.doFilter(request, response);
                            } else
                                ((HttpServletResponse) response)
                                        .setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        } else
                            ((HttpServletResponse) response)
                                    .setStatus(HttpServletResponse.SC_UNAUTHORIZED);


                    } else
                        filterChain.doFilter(request, response);

                } else
                    ((HttpServletResponse) response)
                            .setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            } else
                ((HttpServletResponse) response)
                        .setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
}
