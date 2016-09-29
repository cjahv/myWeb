DROP DATABASE IF EXISTS my_web;
CREATE DATABASE my_web
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE my_web;

CREATE TABLE web_users_headers (
  id  INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  url VARCHAR(255) COMMENT '用户自定义头像绝对路径',
  UNIQUE id(id)
)
  COMMENT '用户头像表';

INSERT INTO web_users_headers (id, url) VALUE (1, NULL);

CREATE TABLE web_users (
  id           INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  username     VARCHAR(20) UNIQUE              NOT NULL
  COMMENT '用户名\n只能为数值字母下划线,长度4-20',
  email        VARCHAR(46) UNIQUE              NOT NULL
  COMMENT '邮件地址',
  password     CHAR(32)                        NOT NULL
  COMMENT '密码\n使用秘钥和原密码进行md5加密',
  header_image INT(11) UNSIGNED COMMENT '用户头像id url不存在时,使用默认头像路径与id拼接',
  last_login   TIMESTAMP                       NOT NULL DEFAULT current_timestamp
  COMMENT '用户最后登录时间\n由程序写入',
  auth TINYINT(1) UNSIGNED DEFAULT 0 COMMENT '用户权限',
  UNIQUE KEY id(id),
  FOREIGN KEY (header_image) REFERENCES web_users_headers (id)
)
  COMMENT '用户表';

INSERT INTO web_users (id, username, email, password, header_image, last_login,auth)
  VALUE (1, 'admin', 'admin@admin.com', '', 1, now(),255);

CREATE TABLE web_articles (
  id              INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  parent_id       INT(11) UNSIGNED COMMENT '上级文章id',
  title           VARCHAR(255)
  COMMENT '文章标题',
  content         TEXT                            NOT NULL
  COMMENT '文章内容',
  content_split   INT(11) UNSIGNED COMMENT '文章内容简介长度',
  click           INT(11) UNSIGNED                NOT NULL        DEFAULT 0
  COMMENT '点击量',
  click_pv        INT(11) UNSIGNED                NOT NULL        DEFAULT 0
  COMMENT 'pv量',
  create_user     INT(11) UNSIGNED COMMENT '创建用户id',
  create_datetime TIMESTAMP                       NOT NULL        DEFAULT current_timestamp
  COMMENT '创建时间',
  change_user     INT(11) UNSIGNED COMMENT '修改用户id',
  change_datetime DATETIME                                        DEFAULT NULL
  COMMENT '修改时间',
  discuss         INT(11) UNSIGNED                NOT NULL        DEFAULT 0
  COMMENT '评论数量',
  UNIQUE id(id),
  FOREIGN KEY (parent_id) REFERENCES web_articles (id),
  FOREIGN KEY (create_user) REFERENCES web_users (id),
  FOREIGN KEY (change_user) REFERENCES web_users (id)
)
  COMMENT '文章表';

INSERT INTO web_articles (parent_id, title, content, content_split, create_user)
VALUES (NULL, '测试文章',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1), (1, NULL, '谢谢', NULL, 1),(NULL, '测试文章',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章1',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章2',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章3',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章4',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章5',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章6',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章7',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1),(NULL, '测试文章8',
        '<p>方法一</p><p>cmd 到mysql bin目录下用 如下命令 mysqldump--opt - h192 .168 .0 .156 - uusername - ppassword--skip - lock - tables databasename &gt;database.sql &nbsp; &nbsp;<br>&nbsp;把ip改成localhost就可以的<br>&nbsp;如果装了navicate那就更简单了 先连接上数据库， 选中数据库 再选择转储sql 就好了<br><br></p><p>方法二<br>进入cmd(注意在os cmd中 而不是在mysql中)<br>&nbsp; === === === === === === =<br>&nbsp;1. 导出数据库（ sql脚本） &nbsp;<br>&nbsp;mysqldump - u 用户名 - p 数据库名 &gt;导出的文件名<br>mysqldump - u root - p db_name &gt;test_db.sql<br>2. mysql导出数据库一个表<br>mysqldump - u 用户名 - p 数据库名 表名 &gt;导出的文件名<br>mysqldump - u wcnc - p test_db users &gt;test_users.sql（ 结尾没有分号）</br></br></br></br></br></br></br></br></p><p>方法三</p><p>启动mysql服务<br>/etc/init.d / mysql start</br></p><p>导出整个数据库<br>mysqldump dbname &gt;c: mydb.sql - u root - p &nbsp;</br></p><p>导入数据库<br>source mydb.sql</br></p><p>mysql - u用户名 - p 数据库名 &lt;数据库名.sql</p><p>更详细的导入数据库教程</p><p><br>2.1.导出sql脚本<br>在原数据库服务器上， 可以用<a href="/phper/php.html" target="_blank">php教程</a>myadmin工具，或者mysqldump(mysqldump命令位于mysql/bin / 目录中) 命令行， 导出sql脚本。<br>2.1 .1 用phpmyadmin工具<br>导出选项中， 选择导出 "结构"和 "数据"，不要添加 "drop database"和 "drop table"选项。<br>选中 "另存为文件"选项， 如果数据比较多， 可以选中 "gzipped"选项。<br>将导出的sql文件保存下来。</br></br></br></br></br></br></p><p>2.1 .2 用mysqldump命令行<br>命令格式<br>mysqldump - u用户名 - p 数据库名 &gt;数据库名.sql<br>范例：<br>mysqldump - uroot - p abc &gt;abc.sql<br>（导出数据库abc到abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p><p>2.2.创建空的数据库<br>通过主控界面 / 控制面板， 创建一个数据库。 假设数据库名为abc， 数据库全权用户为abc_f。</br></p><p>2.3.将sql脚本导入执行<br>同样是两种方法， 一种用phpmyadmin（ mysql数据库管理） 工具， 或者mysql命令行。<br>2.3 .1 用phpmyadmin工具<br>从控制面板， 选择创建的空数据库， 点 "管理"，进入管理工具页面。<br>在 "sql"菜单中， 浏览选择刚才导出的sql文件， 点击 "执行"以上载并执行。</br></br></br></br></p><p>注意： phpmyadmin对上载的文件大小有限制， php本身对上载文件大小也有限制， 如果原始sql文件<br>比较大， 可以先用gzip对它进行压缩， 对于sql文件这样的文本文件， 可获得1: 5 或更高的压缩率。<br>gzip使用方法：<br># gzip xxxxx.sql<br>得到<br>xxxxx.sql.gz文件。</br></br></br></br></br></p><p>2.3 .2 用mysql命令行<br>命令格式<br>mysql - u用户名 - p 数据库名 &lt;数据库名.sql<br>范例：<br>mysql - uabc_f - p abc &lt;abc.sql<br>（导入数据库abc从abc.sql文件）</br></br></br></br></br></p><p>提示输入密码时， 输入该数据库用户名的密码。</p>',
        257, 1);

CREATE TABLE web_config (
  id    INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  `key` VARCHAR(255)                    NOT NULL
  COMMENT '参数键',
  value VARCHAR(1024) COMMENT '参数值',
  UNIQUE id(id)
)
  COMMENT '系统参数表';

INSERT INTO web_config (`key`, value) VALUES ('web.title', '郝都闲人的博客'), ('system.title', '郝都闲人');
