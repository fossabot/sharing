-- 用户表
CREATE TABLE `users`
(
    `id`             BIGINT PRIMARY KEY auto_random, -- 用户ID
    `username`       varchar(32),                    -- 用户名
    `password`       varchar(255),                   -- 密码
    `salt`           char(6),                        -- 密码盐
    `followed_count` int,                            -- 关注数
    `follower_count` int                             -- 粉丝数
);
-- 用户名唯一
alter table users
    add unique (username);

---
CREATE TABLE `videos`
(
    `id`             bigint PRIMARY KEY auto_random, -- 视频ID
    `user_id`        bigint,                         -- 用户ID
    `play_url`       varchar(255),                   -- 播放地址
    `cover_url`      varchar(255),                   -- 封面地址
    `favorite_count` int,                            -- 点赞数
    `comment_count`  int,                            -- 评论数
    `title`          varchar(255),                   -- 标题
    `created_at`     timestamp                       -- 创建时间
);
-- 查询用户投稿的视频，按时间排列
CREATE INDEX `videos_user_id_created_at` ON `videos` (`user_id`, `created_at`);
-- 按时间排序
CREATE INDEX `videos_created_at` ON `videos` (`created_at`);

---
CREATE TABLE `favorites`
(
    `id`        bigint PRIMARY KEY auto_random, -- 点赞记录ID
    `user_id`   bigint,                         -- 用户ID
    `video_id`  bigint,                         -- 视频ID
    `action`    int,                            -- 操作类型，0：未点赞，1：点赞
    `update_at` timestamp                       -- 更新时间
);

-- 通过用户点赞记录查询视频，按时间排序
create index `favorites_index_0` on `favorites` (`user_id`, `update_at`);
-- 对视频点赞，需要保证(user_id, video_id)唯一
alter table `favorites`
    add constraint `favorites_unique_0` unique (`user_id`, `video_id`);

---
CREATE TABLE `comments`
(
    `id`         bigint PRIMARY KEY auto_random, -- 评论ID
    `user_id`    bigint,                         -- 用户ID
    `video_id`   bigint,                         -- 视频ID
    `content`    varchar(255),                   -- 评论内容
    `created_at` varchar(255)                    -- 创建时间
);
-- 查询视频的评论按时间排序
create index comments_index_0 on comments (video_id, created_at);
-- 查询用户评论的视频 （暂时没有需求
-- 查询评论视频的用户 （暂时没有需求
-- 查询用户的评论的视频 （暂时没有需求

---
CREATE TABLE relations
(
    `id`        bigint PRIMARY KEY auto_random, -- 关系ID
    `follower`  bigint,                         -- 粉丝ID
    `followed`  bigint,                         -- 关注ID
    `status`    int,                            -- 关系状态，0：未关注，1：已关注
    `update_at` timestamp                       -- 更新时间
);
-- 查询用户的关注，按时间排序
create index relation_index_0 on relations (follower, update_at);
-- 查询用户的粉丝, 按时间排序
create index relation_index_1 on relations (followed, update_at);
--
--    - 修改关注状态，添加关注或者取消关注，那么需要 (follower, followed) 唯一 (隐式索引)
--    - 查询指定 (follower, followed) 的状态
alter table relations
    add constraint relation_unique_0 unique (follower, followed);
