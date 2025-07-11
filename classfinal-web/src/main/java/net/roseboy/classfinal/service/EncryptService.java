package net.roseboy.classfinal.service;

import net.roseboy.classfinal.JarEncryptor;
import net.roseboy.classfinal.util.IoUtils;
import net.roseboy.classfinal.util.Log;
import net.roseboy.classfinal.util.StrUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * JAR/WAR加密服务
 */
@Service
public class EncryptService {

    /**
     * 处理文件加密请求
     * @param file 上传的文件
     * @param packages 加密的包名
     * @param password 加密密码
     * @param code 机器码
     * @param exclude 排除的类名
     * @param libjars 需要加密的lib下的jar
     * @param classpath 依赖jar包目录
     * @param cfgfiles 需要加密的配置文件
     * @return 加密结果文件路径
     * @throws IOException 文件操作异常
     */
    public String encryptFile(MultipartFile file, String packages, String password, String code, 
                              String exclude, String libjars, String classpath, String cfgfiles) throws IOException {
        // 保存上传的文件到临时目录
        File tempFile = File.createTempFile("upload-", "-" + file.getOriginalFilename());
        file.transferTo(tempFile);
        
        try {
            Log.println("开始加密文件: " + tempFile.getAbsolutePath());
            
            // 准备参数列表
            List<String> packageList = StrUtils.toList(packages);
            List<String> excludeClassList = StrUtils.toList(exclude);
            List<String> includeJarList = StrUtils.toList(libjars);
            List<String> classPathList = StrUtils.toList(classpath);
            List<String> cfgFileList = StrUtils.toList(cfgfiles);
            includeJarList.add("-"); // 添加默认项
            
            // 创建加密器并配置参数
            JarEncryptor encryptor = new JarEncryptor(tempFile.getAbsolutePath(), password.trim().toCharArray());
            encryptor.setCode(StrUtils.isEmpty(code) ? null : code.trim().toCharArray());
            encryptor.setPackages(packageList);
            encryptor.setIncludeJars(includeJarList);
            encryptor.setExcludeClass(excludeClassList);
            encryptor.setClassPath(classPathList);
            encryptor.setCfgfiles(cfgFileList);
            
            // 执行加密
            String result = encryptor.doEncryptJar();
            Log.println("加密完成: " + result);
            
            return result;
        } finally {
            // 可选：加密完成后删除临时文件
            // tempFile.delete();
        }
    }
}