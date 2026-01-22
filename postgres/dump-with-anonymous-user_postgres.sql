CREATE TYPE exposure_t AS ENUM ('public', 'unlisted', 'private');
CREATE TYPE blueprint_type_t AS ENUM ('animation', 'behavior_tree', 'blueprint', 'material', 'metasound', 'niagara', 'pcg');
CREATE TYPE grade_t AS ENUM ('member', 'admin');

create table if not exists blueprints
(
    id SERIAL NOT NULL primary key,
    id_author bigint null,
    slug varchar(100) not null,
    file_id varchar(100) not null,
    title varchar(255) not null,
    type blueprint_type_t default 'blueprint' not null,
    ue_version char(5) default '4.0' not null,
    current_version bigint not null,
    thumbnail varchar(255) null,
    description text null,
    exposure exposure_t default 'public' not null,
    expiration timestamp null,
    tags varchar(255) null,
    video varchar(255) null,
    video_provider varchar(255) null,
    comments_hidden smallint default '0',
    comments_closed smallint default '0',
    comments_count bigint default '0',
    created_at timestamp not null,
    updated_at timestamp null,
    published_at timestamp null,
    deleted_at timestamp null,
    constraint blueprints_file_id_UNIQUE unique (file_id),
    constraint blueprints_slug_UNIQUE unique (slug)
);

create table if not exists blueprints_version
(
    id SERIAL NOT NULL primary key,
    id_blueprint bigint not null,
    version bigint not null,
    reason text not null,
    created_at timestamp not null,
    updated_at timestamp null,
    published_at timestamp null
);

create table if not exists comments
(
    id SERIAL NOT NULL primary key,
    id_author bigint null,
    id_blueprint bigint not null,
    name_fallback varchar(255) null,
    content text not null,
    created_at timestamp not null
);

create table if not exists sessions
(
    id varchar(128) not null primary key,
    id_user bigint null,
    last_access timestamp not null,
    content text not null
);

create table if not exists tags
(
    id SERIAL NOT NULL primary key,
    name varchar(100) not null,
    slug varchar(100) not null,
    constraint tags_slug_UNIQUE unique (slug)
);

create table if not exists users
(
    id SERIAL NOT NULL primary key,
    username varchar(100) not null,
    password text null,
    slug varchar(100) not null,
    email varchar(100) null,
    password_reset varchar(255) null,
    password_reset_at timestamp null,
    grade grade_t default 'member' not null,
    avatar varchar(255) null,
    remember_token char(255) null,
    created_at timestamp not null,
    confirmed_token char(255) null,
    confirmed_sent_at timestamp null,
    confirmed_at timestamp null,
    last_login_at timestamp null,
    constraint users_email_UNIQUE unique (email),
    constraint users_username_UNIQUE unique (username),
    constraint users_slug_UNIQUE unique (slug),
    constraint users_remember_token_UNIQUE unique (remember_token),
    constraint users_confirmed_token_UNIQUE unique (confirmed_token)
);

create table if not exists users_api
(
    id_user SERIAL NOT NULL primary key,
    api_key varchar(100) not null,
    constraint users_api_api_key_UNIQUE unique (api_key)
);

create table if not exists users_infos
(
    id_user SERIAL NOT NULL primary key,
    count_public_blueprint bigint default 0 not null,
    count_public_comment bigint default 0 not null,
    count_private_blueprint bigint default 0 not null,
    count_private_comment bigint default 0 not null,
    bio text null,
    link_website varchar(255) null,
    link_facebook varchar(255) null,
    link_twitter varchar(255) null,
    link_github varchar(255) null,
    link_twitch varchar(255) null,
    link_unreal varchar(255) null,
    link_youtube varchar(255) null
);

INSERT INTO users (id, username, password, slug, email, password_reset, password_reset_at, grade, avatar, remember_token, created_at, confirmed_token, confirmed_sent_at, confirmed_at) VALUES ('1', 'anonymous', NULL, 'anonymous', NULL, NULL, NOW(), 'member', NULL, NULL, NOW(), NULL, NOW(), NOW());
INSERT INTO users_infos (id_user, count_public_blueprint, count_public_comment, count_private_blueprint, count_private_comment, bio, link_website, link_facebook, link_twitter, link_github, link_twitch, link_unreal, link_youtube) VALUES ('1', '0', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
