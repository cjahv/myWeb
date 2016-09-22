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
  last_login   TIMESTAMP NOT NULL DEFAULT current_timestamp
  COMMENT '用户最后登录时间\n由程序写入',
  UNIQUE KEY id(id),
  FOREIGN KEY (header_image) REFERENCES web_users_headers (id)
)
  COMMENT '用户表';

INSERT INTO web_users (id, username, email, password, header_image, last_login)
  VALUE (1, 'admin', 'admin@admin.com', '1111111111111111111111111111111', 1, now());

CREATE TABLE web_articles (
  id              INT(11) UNSIGNED AUTO_INCREMENT NOT NULL,
  parent_id       INT(11) UNSIGNED COMMENT '上级文章id',
  title           VARCHAR(255)
  COMMENT '文章标题',
  content         TEXT                            NOT NULL
  COMMENT '文章内容',
  click           INT(11) UNSIGNED                NOT NULL DEFAULT 0
  COMMENT '点击量',
  click_pv        INT(11) UNSIGNED                NOT NULL DEFAULT 0
  COMMENT 'pv量',
  create_user     INT(11) UNSIGNED COMMENT '创建用户id',
  create_datetime TIMESTAMP                       NOT NULL DEFAULT current_timestamp
  COMMENT '创建时间',
  change_user     INT(11) UNSIGNED COMMENT '修改用户id',
  change_datetime TIMESTAMP                                DEFAULT 0 ON UPDATE current_timestamp
  COMMENT '修改时间',
  UNIQUE id(id),
  FOREIGN KEY (parent_id) REFERENCES web_articles (id),
  FOREIGN KEY (create_user) REFERENCES web_users (id),
  FOREIGN KEY (change_user) REFERENCES web_users (id)
)
  COMMENT '文章表';

INSERT INTO web_articles (parent_id, title, content, create_user)
VALUES (NULL, '欢迎使用', '这是第一篇文章', 1), (1, NULL, '谢谢', 1);
