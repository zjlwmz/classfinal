package net.roseboy.classfinal.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import net.roseboy.classfinal.service.EncryptService;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;


@RestController
@RequestMapping("/")
public class EncryptController {



    @Autowired
    private EncryptService encryptService;


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
    public Object encryptFile(
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
            
            // 3. 返回加密后的文件路径
            return new EncryptResponse(true, "加密成功", resultPath);
        } catch (IOException e) {
            model.addAttribute("error", "文件处理错误: " + e.getMessage());
            return "error";
        } catch (Exception e) {
            model.addAttribute("error", "加密过程发生错误: " + e.getMessage());
            return "error";
        }
    }

    // 文件下载接口
    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam("path") String filePath) {
        try {
            // 安全检查：确保文件路径在允许的目录内
            if (!isPathAllowed(filePath)) {
                return ResponseEntity.badRequest().build();
            }
            
            // 获取文件资源
            File file = new File(filePath);
            Resource resource = new FileSystemResource(file);
            
            // 设置响应头
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + file.getName());
            
            // 返回文件
            return ResponseEntity.ok()
                    .headers(headers)
                    .contentLength(file.length())
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(resource);
                    
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.notFound().build();
        }
    }
    
    // 安全检查：确保文件路径在允许的目录内
    private boolean isPathAllowed(String filePath) {
        // 示例：只允许下载临时目录中的文件
        String tempDir = System.getProperty("java.io.tmpdir");
        return filePath.startsWith(tempDir);
    }   

    // 加密响应类
    static class EncryptResponse {
        private boolean success;
        private String message;
        private String resultPath;
        
        public EncryptResponse(boolean success, String message, String resultPath) {
            this.success = success;
            this.message = message;
            this.resultPath = resultPath;
        }
        
        // getters
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public String getResultPath() { return resultPath; }
    }
}
