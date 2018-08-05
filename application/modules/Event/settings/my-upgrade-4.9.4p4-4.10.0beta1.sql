-- --------------------------------------------------------

--
-- Cover photo work
--

INSERT IGNORE INTO `engine4_activity_actiontypes` (`type`, `module`, `body`, `enabled`, `displayable`, `attachable`, `commentable`, `shareable`, `editable`, `is_generated`) VALUES
('event_cover_photo_update', 'event', '{item:$subject} has updated {item:$object} cover photo.', 1, 5, 1, 4, 1, 0, 1);

ALTER TABLE `engine4_event_events` ADD `coverphoto` INT ( 11 ) NOT NULL DEFAULT '0';

ALTER TABLE `engine4_event_albums` ADD (`coverphotoparams` VARCHAR ( 265 ) NULL, `type` VARCHAR ( 265 ) NULL);

INSERT IGNORE INTO `engine4_authorization_permissions`
  SELECT
    level_id as `level_id`,
    'event' as `type`,
    'coverphotoupload' as `name`,
    1 as `value`,
    NULL as `params`
FROM `engine4_authorization_levels` WHERE `type` NOT IN('public');
