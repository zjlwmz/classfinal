$(document).ready(function () {
    // 多步骤表单逻辑
    var current_fs, next_fs, previous_fs; // 当前、下一个、上一个字段集
    var left, opacity, scale; // 字段集属性
    var animating; // 动画标志，防止多重点击

    // 下一步按钮点击事件
    $(".next").click(function () {
        if (animating) return false;
        animating = true;

        current_fs = $(this).parent();
        next_fs = $(this).parent().next();

        // 显示进度条中的下一步
        $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

        // 显示下一个字段集
        next_fs.show();

        // 隐藏当前字段集
        current_fs.animate({ opacity: 0 }, {
            step: function (now, mx) {
                // 缩放当前字段集
                scale = 1 - (1 - now) * 0.2;
                // 移动当前字段集到左侧
                left = (now * 50) + "%";
                // 调整不透明度
                opacity = 1 - now;
                current_fs.css({
                    'transform': 'scale(' + scale + ')',
                    'position': 'absolute'
                });
                next_fs.css({ 'left': left, 'opacity': opacity });
            },
            duration: 800,
            complete: function () {
                current_fs.hide();
                animating = false;

                // 如果是最后一步，显示确认信息
                if (next_fs.index() === 2) {
                    showConfirmation();
                }
            },
            easing: 'easeInOutBack'
        });
    });

    // 上一步按钮点击事件
    $(".previous").click(function () {
        if (animating) return false;
        animating = true;

        current_fs = $(this).parent();
        previous_fs = $(this).parent().prev();

        // 更新进度条
        $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

        // 显示上一个字段集
        previous_fs.show();

        // 隐藏当前字段集
        current_fs.animate({ opacity: 0 }, {
            step: function (now, mx) {
                // 缩放前一个字段集
                scale = 0.8 + (1 - now) * 0.2;
                // 移动当前字段集到右侧
                left = ((1 - now) * 50) + "%";
                // 调整不透明度
                opacity = 1 - now;
                current_fs.css({ 'left': left, 'opacity': opacity });
                previous_fs.css({
                    'transform': 'scale(' + scale + ')',
                    'position': 'absolute'
                });
            },
            duration: 800,
            complete: function () {
                current_fs.hide();
                animating = false;
            },
            easing: 'easeInOutBack'
        });
    });

    // 显示确认信息
    function showConfirmation() {
        var file = $("#file").val().split('\\').pop();
        var password = $("#password").val();
        var packages = $("#packages").val() || "全部包";
        var code = $("#code").val() || "无";
        var exclude = $("#exclude").val() || "无";

        var confirmInfo = `
                    <p><strong>文件:</strong> ${file}</p>
                    <p><strong>加密密码:</strong> ${password}</p>
                    <p><strong>加密的包名:</strong> ${packages}</p>
                    <p><strong>机器码:</strong> ${code}</p>
                    <p><strong>排除的类名:</strong> ${exclude}</p>
                `;

        $("#confirm-info").html(confirmInfo);
    }

    // 提交按钮点击事件
    $("#submit-btn").click(function () {
        // 创建表单数据
        var formData = new FormData();
        formData.append("file", $("#file")[0].files[0]);
        formData.append("password", $("#password").val());
        formData.append("packages", $("#packages").val());
        formData.append("code", $("#code").val());
        formData.append("exclude", $("#exclude").val());

        // 显示加载状态
        $(this).val("加密中...").prop("disabled", true);

        // 发送AJAX请求
        $.ajax({
            url: "/encrypt",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                // 显示成功信息
                $("#success-message").text("加密成功！");

                // 设置下载链接
                $("#download-link").attr("href", response.resultPath);

                // 自动点击下一步
                $(".next").click();
            },
            error: function (xhr, status, error) {
                alert("加密失败: " + xhr.responseJSON.error);
                $("#submit-btn").val("开始加密").prop("disabled", false);
            }
        });
    });
});