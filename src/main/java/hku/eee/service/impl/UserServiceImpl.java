package hku.eee.service.impl;

import hku.eee.dao.AccountDao;
import hku.eee.dao.ParkDao;
import hku.eee.domain.Account;
import hku.eee.domain.Park;
import hku.eee.domain.User;
import hku.eee.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.util.StringUtils;

import java.util.ArrayList;

public class UserServiceImpl implements UserService, UserDetailsService {

    @Autowired
    private AccountDao accountDao;

    @Autowired
    private ParkDao parkDao;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        if(StringUtils.isEmpty(username)) {
            throw new BadCredentialsException("Username can not be empty!");
        }
        String userRole = username.substring(0, 7);
        String userLoginName = username.substring(7);
        System.out.println("!!!!!!!!!!!!!!!!!!" + userLoginName);
        if("account".equals(userRole)) {

            /*-- super administrator

            if("adminlxr".equals(userLoginName)) {
                authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                return new User(userLoginName, "123456", authorities);
            }
            end*/

            Account account = accountDao.findByUserName(userLoginName);
            if (account == null)
                throw new BadCredentialsException("Username does not exist!");

            ArrayList<SimpleGrantedAuthority> authorities = new ArrayList();
            authorities.add(new SimpleGrantedAuthority("ROLE_ACCOUNT"));
            System.out.println("!!!!!!!!!!!!!!!!!!!!!");
            return new User(userLoginName, account.getPassword(), userRole, authorities);
        }
        else if("parkbay".equals(userRole)) {
            Park park = parkDao.findByUserName(userLoginName);
            System.out.println(park+"authority park!!!!!!!");
            if (park == null)
                throw new BadCredentialsException("Username does not exist!");
            ArrayList<SimpleGrantedAuthority> authorities = new ArrayList();
            authorities.add(new SimpleGrantedAuthority("ROLE_PARKHOST"));
            return new User(userLoginName, park.getPassword(), userRole, authorities);
        }
        else
            throw new BadCredentialsException("Username does not exist!");






    }
}
