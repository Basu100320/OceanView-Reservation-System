package filter;

import org.junit.jupiter.api.Test;

import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.*;

class AuthFilterTest {

    AuthFilter filter = new AuthFilter();

    @Test
    void doFilter() throws Exception {

        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        FilterChain chain = mock(FilterChain.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("username")).thenReturn("admin");
        when(request.getContextPath()).thenReturn("");
        when(request.getRequestURI()).thenReturn("/dashboard.jsp");

        filter.doFilter(request, response, chain);

        verify(chain, times(1)).doFilter(request, response);
    }

    @Test
    void init() throws Exception {

        FilterConfig config = mock(FilterConfig.class);

        filter.init(config);

        assertNotNull(filter);
    }

    @Test
    void destroy() {

        filter.destroy();

        assertNotNull(filter);
    }
}