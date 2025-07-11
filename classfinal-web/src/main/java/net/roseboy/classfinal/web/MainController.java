package net.roseboy.classfinal.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import net.roseboy.classfinal.service.EncryptService;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MainController {



    @Autowired
    private EncryptService encryptService;

    @GetMapping("/")
    public String index(HttpServletRequest request) {
        request.setAttribute("ttt", "rrrrr");
        return "index";
    }



     /**
     * 处理文件加密请求
     * @param file 上传的JAR/WAR文件
     * @param packages 加密的包名
     * @param password 加密密码
     * @param code 机器码
     * @param exclude 排除的类名
     * @param libjars 需要加密的lib下的jar
     * @param classpath 依赖jar包目录
     * @param cfgfiles 需要加密的配置文件
     * @param model 视图模型
     * @return 结果视图
     */
    @PostMapping("/encrypt")
    public String encryptFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "packages", required = false) String packages,
            @RequestParam("password") String password,
            @RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "exclude", required = false) String exclude,
            @RequestParam(value = "libjars", required = false) String libjars,
            @RequestParam(value = "classpath", required = false) String classpath,
            @RequestParam(value = "cfgfiles", required = false) String cfgfiles,
            Model model) {
        
        try {
            // 验证文件是否上传
            if (file.isEmpty()) {
                model.addAttribute("error", "请选择要上传的文件");
                return "error";
            }
            
            // 调用加密服务
            String resultPath = encryptService.encryptFile(
                    file, packages, password, code, exclude, libjars, classpath, cfgfiles);
            
            // 将结果添加到模型
            model.addAttribute("resultPath", resultPath);
            model.addAttribute("password", password);
            
            return "success"; // 返回成功页面
        } catch (IOException e) {
            model.addAttribute("error", "文件处理错误: " + e.getMessage());
            return "error";
        } catch (Exception e) {
            model.addAttribute("error", "加密过程发生错误: " + e.getMessage());
            return "error";
        }
    }
}
