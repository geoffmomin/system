CREATE TABLE {$prefix}posts ( 
	id INT UNSIGNED NOT NULL AUTO_INCREMENT
,	slug VARCHAR(255) NOT NULL
,	content_type SMALLINT UNSIGNED NOT NULL
,	title VARCHAR(255) NOT NULL
,	guid VARCHAR(255) NOT NULL
,	content LONGTEXT NOT NULL
,	cached_content LONGTEXT NOT NULL
,	user_id SMALLINT UNSIGNED NOT NULL
,	status SMALLINT UNSIGNED NOT NULL
,	pubdate DATETIME NOT NULL 
,	updated TIMESTAMP NOT NULL
, PRIMARY KEY (id)
, UNIQUE INDEX (slug(80))
);

CREATE TABLE  {$prefix}postinfo  ( 
	post_id INT UNSIGNED NOT NULL
,	name VARCHAR(255) NOT NULL
,	type SMALLINT UNSIGNED NOT NULL DEFAULT 0
,	value TEXT
, PRIMARY KEY (post_id, name)
);

CREATE TABLE  {$prefix}posttype ( 
	id INT UNSIGNED NOT NULL AUTO_INCREMENT
,	name VARCHAR(255) NOT NULL 
, PRIMARY KEY (id)
);

INSERT INTO  {$prefix}posttype (name) VALUES ("entry");
INSERT INTO {$prefix}posttype (name) VALUES ("page");

CREATE TABLE  {$prefix}poststatus ( 
	id INT UNSIGNED NOT NULL AUTO_INCREMENT
,	name VARCHAR(255) NOT NULL 
, PRIMARY KEY (id)
);

INSERT INTO  {$prefix}poststatus (name) VALUES ("draft");
INSERT INTO  {$prefix}poststatus (name) VALUES ("published");
INSERT INTO  {$prefix}poststatus (name) VALUES ("private");

CREATE TABLE  {$prefix}options (
	name VARCHAR(255) NOT NULL
,	type SMALLINT UNSIGNED NOT NULL DEFAULT 0
,	value TEXT
, PRIMARY KEY (name)
);

CREATE TABLE  {$prefix}users (
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT
,	username VARCHAR(255) NOT NULL
,	email VARCHAR(255) NOT NULL
,	password VARCHAR(255) NOT NULL
, PRIMARY KEY (id)
, UNIQUE INDEX (username)
);

CREATE TABLE  {$prefix}userinfo ( 
	user_id SMALLINT UNSIGNED NOT NULL
,	name VARCHAR(255) NOT NULL
,	type SMALLINT UNSIGNED NOT NULL DEFAULT 0
,	value TEXT
, PRIMARY KEY (user_id, name)
);

CREATE TABLE  {$prefix}tags (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT
, tag_text VARCHAR(255) NOT NULL
, tag_slug VARCHAR(255) NOT NULL
, PRIMARY KEY (id)
, UNIQUE INDEX (tag_text)	
);

CREATE TABLE  {$prefix}tag2post (
  tag_id INT UNSIGNED NOT NULL
, post_id INT UNSIGNED NOT NULL
, PRIMARY KEY (tag_id, post_id)
, INDEX (post_id)
);

CREATE TABLE  {$prefix}themes (
  id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT
, name VARCHAR(255) NOT NULL
, version VARCHAR(255) NOT NULL
, template_engine VARCHAR(255) NOT NULL
, theme_dir VARCHAR(255) NOT NULL
, is_active TINYINT UNSIGNED NOT NULL DEFAULT 0
, PRIMARY KEY (id)
);

INSERT INTO  {$prefix}themes (
  id
, name
, version
, template_engine
, theme_dir
, is_active
) VALUES (
  NULL
, "k2"
, "1.0"
, "rawphpengine"
, "k2"
, 1
);

CREATE TABLE  {$prefix}comments (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT
,	post_id INT UNSIGNED NOT NULL
,	name VARCHAR(255) NOT NULL
,	email VARCHAR(255) NOT NULL
,	url VARCHAR(255) NULL
,	ip INT UNSIGNED NOT NULL
,	content TEXT
,	status TINYINT UNSIGNED NOT NULL
,	date TIMESTAMP NOT NULL
,	type SMALLINT UNSIGNED NOT NULL
, PRIMARY KEY (id)
, INDEX (post_id)
);

CREATE TABLE  {$prefix}commentinfo ( 
	comment_id INT UNSIGNED NOT NULL
,	name VARCHAR(255) NOT NULL
,	type SMALLINT UNSIGNED NOT NULL DEFAULT 0
,	value TEXT NULL
, PRIMARY KEY (comment_id, name)
);

CREATE TABLE {$prefix}rewrite_rules (
  rule_id INT UNSIGNED NOT NULL AUTO_INCREMENT
, name VARCHAR(255) NOT NULL
, parse_regex VARCHAR(255) NOT NULL
, build_str VARCHAR(255) NOT NULL
, handler VARCHAR(255) NOT NULL
, action VARCHAR(255) NOT NULL
, priority SMALLINT UNSIGNED NOT NULL
, is_active TINYINT UNSIGNED NOT NULL DEFAULT 0
, rule_class TINYINT UNSIGNED NOT NULL DEFAULT 0
, description TEXT NULL
, PRIMARY KEY (rule_id)
);

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'display_posts_at_page','/^page\\/([\\d]+)[\\/]{0,1}$/i','page/{$page}'
,'UserThemeHandler','display_posts',1,'Displays posts.  Page (of post) parameter is passed in URL');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'display_posts_by_date','/([1,2]{1}[\\d]{3})\\/([\\d]{2})\\/([\\d]{2})[\\/]{0,1}$/','{$year}/{$month}/{$day}'
,'UserThemeHandler','display_posts',2,'Displays posts for a specific date.');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'display_posts_by_month','/([1,2]{1}[\\d]{3})\\/([\\d]{2})[\\/]{0,1}$/','{$year}/{$month}'
,'UserThemeHandler','display_posts',3,'Displays posts for a specific month.');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'display_posts_by_year','/([1,2]{1}[\\d]{3})[\\/]{0,1}$/','{$year}'
,'UserThemeHandler','display_posts',4,'Displays posts for a specific year.');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'display_feed_by_type','/^feed\\/(atom|rs[sd])[\\/]{0,1}$/i','feed/{$feed_type}'
,'FeedHandler','display_feed',5,'Return feed per specified feed type');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'display_posts_by_tag','/^tag\\/([^\\/]*)[\\/]{0,1}$/i','tag/{$tag}'
,'UserThemeHandler','display_posts',5,'Return posts matching specified tag');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'admin','/^admin[\\/]*([^\\/]*)[\\/]{0,1}$/i','admin/{$page}'
,'AdminHandler','admin',6,'An admin action');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'userprofile', '/^admin\\/(user)\\/([^\\/]+)\\/{0,1}$/i', 'admin/{$page}/{$user}', 'AdminHandler', 'admin', 4, 'The profile page for a specific user');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'user','/^user\\/([^\\/]*)[\\/]{0,1}$/i','user/{$page}'
,'UserHandler','{$page}',7,'A user action or display, for instance the login screen');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'display_posts_by_slug','/([^\\/]+)[\\/]{0,1}$/i','{$slug}'
,'UserThemeHandler','display_posts',99,'Return posts matching specified slug');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'index_page','//',''
,'UserThemeHandler','display_posts',1000,'Homepage (index) display');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'rsd','/^rsd$/i','rsd'
,'AtomHandler','rsd',1,'RSD output');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'introspection','/^atom$/i','atom'
,'AtomHandler','introspection',1,'Atom introspection');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'collection','/^atom\\/(.+)[\\/]{0,1}$/i','atom/{$index}'
,'AtomHandler','collection',1,'Atom collection');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'search','/^search$/i','search'
,'UserThemeHandler','search',8,'Searches posts');

INSERT INTO {$prefix}rewrite_rules
(rule_id, name, parse_regex, build_str, handler, action, priority, description)
VALUES (NULL, 'comment','/^([0-9]+)\\/feedback[\\/]{0,1}$/i','{$id}/feedback'
,'FeedbackHandler','add_comment',8,'Adds a comment to a post');

UPDATE {$prefix}rewrite_rules SET is_active=1;
