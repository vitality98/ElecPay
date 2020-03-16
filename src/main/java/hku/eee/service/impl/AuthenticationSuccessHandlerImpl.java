package hku.eee.service.impl;

import hku.eee.domain.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class AuthenticationSuccessHandlerImpl implements AuthenticationSuccessHandler {
    @Override
    public void onAuthenticationSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {

        SimpleGrantedAuthority authority = null;
        List<? extends GrantedAuthority> authorities = (List) authentication.getAuthorities();
        for (GrantedAuthority auth : authorities) {
            authority = (SimpleGrantedAuthority) auth;
        }
        if("ROLE_ACCOUNT".equals(authority.getAuthority()))
            httpServletResponse.sendRedirect("/accounthome/accounthome.html");
        else
            httpServletResponse.sendRedirect("/park/parkhome.do");
    }
}
