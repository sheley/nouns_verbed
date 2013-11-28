CREATE TABLE `tracked_things` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `noun_singular` varchar(50) NOT NULL DEFAULT '',
  `noun_plural` varchar(50) NOT NULL DEFAULT '',
  `verb_base` varchar(50) NOT NULL DEFAULT '',
  `verb_past` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(64) NOT NULL,
  `salt` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_unique` (`username`),
  UNIQUE (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tracking_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `count` int(11) NOT NULL,
  `tracked_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_tracked_id` (`tracked_id`),
  CONSTRAINT `tracked_id` FOREIGN KEY (`tracked_id`) REFERENCES `tracked_things` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users_things` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id_` int(11) unsigned NOT NULL,
  `tracked_id_` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_tracked_id` (`tracked_id`),
  CONSTRAINT `tracked_id` FOREIGN KEY (`tracked_id`) REFERENCES `tracked_things` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



################## WITHOUT USERS

CREATE TABLE `tracked_things` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `noun_singular` varchar(50) NOT NULL DEFAULT '',
  `noun_plural` varchar(50) NOT NULL DEFAULT '',
  `verb_base` varchar(50) NOT NULL DEFAULT '',
  `verb_past` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;



CREATE TABLE `tracking_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `count` int(11) NOT NULL,
  `tracked_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tracked_id` (`tracked_id`),
  CONSTRAINT `tracked_id` FOREIGN KEY (`tracked_id`) REFERENCES `tracked_things` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;


#################### users

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(64) NOT NULL,
  `salt` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT (`idx_unique`) UNIQUE (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
