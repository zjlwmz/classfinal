<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ClassFinal</title>
    <style>
        /* 基础样式 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f8;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }
        
        /* 表单容器 */
        #msform {
            width: 100%;
            max-width: 800px;
            margin: 50px auto;
            text-align: center;
            position: relative;
            padding: 20px 0;
        }
        
        /* 进度条 */
        #progressbar {
            margin-bottom: 40px;
            overflow: hidden;
            counter-reset: step;
            padding: 0;
            display: flex;
            justify-content: space-between;
            z-index: 10; /* 确保进度条在最上层 */
            position: relative; /* 添加相对定位 */
        }
        
        #progressbar li {
            list-style-type: none;
            color: #666;
            text-transform: uppercase;
            font-size: 12px;
            flex: 1;
            position: relative;
            text-align: center;
            min-height: 60px; /* 确保有足够高度显示 */
            display: flex; /* 使用flex布局 */
            flex-direction: column; /* 垂直排列内容 */
            align-items: center; /* 水平居中 */
        }
        
        #progressbar li:before {
            content: counter(step);
            counter-increment: step;
            width: 30px;
            height: 30px;
            line-height: 30px;
            display: block;
            font-size: 14px;
            color: #333;
            background: white;
            border-radius: 50%;
            margin: 0 auto 10px auto;
            border: 2px solid #ddd;
            transition: all 0.3s ease;
            z-index: 2; /* 确保数字在连线上方 */
        }
        
        /* 进度条连接线 */
        #progressbar li:after {
            content: '';
            width: 100%;
            height: 2px;
            background: #ddd;
            position: absolute;
            left: -50%;
            top: 14px;
            z-index: 1; /* 确保连线在数字下方 */
            transition: all 0.3s ease;
        }
        
        #progressbar li:first-child:after {
            content: none;
        }
        
        /* 激活和完成状态的步骤样式 */
        #progressbar li.active:before {
            background: #27AE60;
            color: white;
            border-color: #27AE60;
        }
        
        #progressbar li.active:after {
            background: #27AE60;
        }
        
        #progressbar li.active {
            color: #27AE60;
            font-weight: bold;
        }
        
        /* 字段集 */
        fieldset {
            background: white;
            border: 0 none;
            border-radius: 8px;
            box-shadow: 0 0 15px 1px rgba(0, 0, 0, 0.1);
            padding: 30px;
            box-sizing: border-box;
            width: 100%;
            margin: 0;
            position: absolute;
            top: 100px; /* 调整位置，确保不覆盖进度条 */
            left: 0;
            transition: all 0.3s ease;
            z-index: 5; /* 确保表单在进度条下方 */
        }
        
        /* 隐藏所有字段集，除了第一个 */
        fieldset:not(:first-of-type) {
            display: none;
            opacity: 0;
            transform: translateY(20px);
        }
        
        /* 输入和按钮样式 */
        input, textarea {
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 15px;
            width: 100%;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
            color: #333;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        
        input:focus, textarea:focus {
            outline: none;
            border-color: #27AE60;
            box-shadow: 0 0 0 2px rgba(39, 174, 96, 0.2);
        }
        
        .action-button {
            width: 120px;
            background: #27AE60;
            font-weight: bold;
            color: white;
            border: 0 none;
            border-radius: 4px;
            cursor: pointer;
            padding: 12px 0;
            margin: 15px 5px;
            transition: all 0.3s ease;
            font-size: 14px;
        }
        
        .action-button:hover, .action-button:focus {
            box-shadow: 0 0 0 2px white, 0 0 0 4px #27AE60;
            background: #219653;
        }
        
        /* 标题样式 */
        .fs-title {
            font-size: 20px;
            text-transform: uppercase;
            color: #2C3E50;
            margin-bottom: 10px;
            font-weight: bold;
        }
        
        .fs-subtitle {
            font-weight: normal;
            font-size: 15px;
            color: #666;
            margin-bottom: 25px;
        }
        
        /* 确认信息样式 */
        #confirm-info {
            text-align: left;
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 4px;
            border: 1px solid #eee;
        }
        
        #confirm-info p {
            margin: 8px 0;
            font-size: 14px;
        }
        
        #confirm-info strong {
            color: #2C3E50;
        }
        
        /* 成功页面样式 */
        .success-message {
            color: #27AE60;
            font-size: 18px;
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f0fff4;
            border-radius: 4px;
            border: 1px solid #c6eccd;
        }
        
        .download-link {
            display: inline-block;
            background: #27AE60;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            transition: all 0.3s ease;
            margin: 10px 0;
            font-size: 14px;
        }
        
        .download-link:hover {
            background: #219653;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        /* 响应式调整 */
        @media (max-width: 768px) {
            #msform {
                width: 90%;
                margin: 30px auto;
            }
            
            fieldset {
                padding: 20px;
                top: 80px; /* 小屏幕上调整位置 */
            }
            
            .action-button {
                width: 100px;
                padding: 10px 0;
                font-size: 13px;
            }
            
            .fs-title {
                font-size: 18px;
            }
            
            .fs-subtitle {
                font-size: 14px;
            }
            
            #progressbar li {
                font-size: 11px;
            }
        }
        
        /* 文件上传按钮样式 */
        input[type="file"] {
            padding: 10px;
            border: 1px dashed #ddd;
            background-color: #f9f9f9;
        }
        
        /* 加密按钮特殊样式 */
        #submit-btn {
            background: #e74c3c;
        }
        
        #submit-btn:hover, #submit-btn:focus {
            box-shadow: 0 0 0 2px white, 0 0 0 4px #e74c3c;
            background: #c0392b;
        }
    </style>
</head>

<body>
    <form id="msform">
        <!-- 进度条 -->
        <ul id="progressbar">
            <li class="active">上传jar/war包</li>
            <li>加密参数</li>
            <li>加密确认</li>
            <li>加密完成</li>
        </ul>
        <!-- 字段集 -->
        <fieldset>
            <h2 class="fs-title">Upload</h2>
            <h3 class="fs-subtitle">上传您的jar或war文件</h3>
            <input type="file" name="file" id="file" accept=".jar,.war" required>
            <input type="password" name="password" id="password" placeholder="加密密码" required>
            <input type="button" name="next" class="next action-button" value="下一步">
        </fieldset>
        <fieldset>
            <h2 class="fs-title">Settings</h2>
            <h3 class="fs-subtitle">设置加密参数</h3>
            <input type="text" name="packages" id="packages" placeholder="加密的包名(多个包用逗号分隔)">
            <input type="text" name="code" id="code" placeholder="机器码">
            <input type="text" name="exclude" id="exclude" placeholder="排除的类名(多个类用逗号分隔)">
            <input type="button" name="previous" class="previous action-button" value="上一步">
            <input type="button" name="next" class="next action-button" value="下一步">
        </fieldset>
        <fieldset>
            <h2 class="fs-title">Confirm</h2>
            <h3 class="fs-subtitle">确认加密参数</h3>
            <div id="confirm-info" style="text-align: left; margin-bottom: 20px;"></div>
            <input type="button" name="previous" class="previous action-button" value="上一步">
            <input type="button" name="next" class="next action-button" id="submit-btn" value="开始加密">
        </fieldset>
        <fieldset>
            <h2 class="fs-title">Complete</h2>
            <h3 class="fs-subtitle">加密完成</h3>
            <div id="success-message" class="success-message"></div>
            <a href="#" id="download-link" class="download-link">下载加密文件</a>
            <input type="button" name="previous" class="previous action-button" value="返回首页">
        </fieldset>
    </form>
    
    <!-- 调试信息 -->
    <div id="debug-info" style="position: fixed; bottom: 10px; left: 10px; background-color: rgba(0,0,0,0.7); color: white; padding: 10px; font-size: 12px; z-index: 100;"></div>
    
    <script src="js/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="js/jquery.easing.min.js" type="text/javascript"></script>
    <script src="js/index.js" type="text/javascript"></script>
    
    <script>
        // 添加调试信息
        $(document).ready(function() {
            // 显示进度条信息
            var progressbarInfo = "进度条状态: " + $("#progressbar li.active").text();
            $("#debug-info").html(progressbarInfo);
            
            // 监听进度条变化
            $(document).on("click", ".next, .previous", function() {
                setTimeout(function() {
                    var progressbarInfo = "进度条状态: " + $("#progressbar li.active").text();
                    $("#debug-info").html(progressbarInfo);
                }, 500);
            });
        });
    </script>
</body>
</html>