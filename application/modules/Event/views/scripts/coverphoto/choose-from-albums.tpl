<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: choose-from-albums.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Alex
 */
?>
<?php
  $this->headLink()
    ->appendStylesheet($this->layout()->staticBaseUrl . 'application/modules/Core/externals/styles/coverphoto.css'); ?>
<div class="global_form_popup">
  <?php if ($this->album_id || $this->recentAdded): ?>
    <?php if ($this->photoType == 'cover') : ?>
      <h3><?php echo $this->translate("Choose Event Cover Photo") ?></h3>
    <?php else: ?>
      <h3><?php echo $this->translate("Choose Event Profile Picture") ?></h3>
    <?php endif; ?>
  <?php else : ?>
    <?php if ($this->photoType == 'cover') : ?>
      <h3><?php echo $this->translate("Select Album to choose Event Cover Photo") ?></h3>
    <?php else : ?>
      <h3><?php echo $this->translate("Select Album to choose Event Profile Picture") ?></h3>
    <?php endif; ?>
  <?php endif; ?>
<?php if ($this->album_id || $this->recentAdded): ?>
  <div class="popup_options">
    <div class="popup_options_left">
      <b><?php echo $this->album_id ? $this->translate("Photos in %s", $this->album->getTitle()) : $this->translate("Event Photos"); ?></b>
    </div>
  </div>
<?php endif; ?>
  <div class="popup_content">
    <?php if ($this->album_id || $this->recentAdded): ?>
      <?php if ($this->paginator && $this->paginator->getTotalItemCount() > 0) : ?>
        <div class="clr choose_photos_content">
          <ul class="thumbs">
            <?php foreach ($this->paginator as $photo): ?>
              <li>
                <a href="<?php echo $this->url(array('action' => 'upload-cover-photo', 'event_id' => $this->event->event_id, 'photo_id' => $photo->photo_id, 'format' => 'smoothbox', 'photoType' => $this->photoType), 'event_coverphoto', true); ?>" title="<?php echo $photo->title; ?>" class="thumbs_photo">
                  <span style="background-image: url(<?php echo $photo->getPhotoUrl('thumb.normal'); ?>);"></span>
                </a>
              </li>
            <?php endforeach; ?>
          </ul>
        </div>
      <?php else: ?>
        <div class="tip" style="margin-top:10px;">
          <span>
            <?php echo $this->translate("No photos found.") ?>
          </span>
        </div>
      <?php endif; ?>
    <?php else: ?>
      <?php if ($this->paginator && $this->paginator->getTotalItemCount() > 0) : ?>
        <div class="clr choose_photos_content">
          <ul class="thumbs">
            <?php foreach ($this->paginator as $albums): ?>
              <?php if (count($albums) < 1): continue;
              endif; ?>
              <li>
                <?php if ($albums->photo_id != 0): ?>
                  <a href="<?php echo $this->url(array('action' => 'choose-from-albums', 'event_id' => $this->event->event_id, 'album_id' => $albums->album_id, 'format' => 'smoothbox', 'photoType' => $this->photoType), 'event_coverphoto', true); ?>" title="<?php echo $albums->title; ?>" class="thumbs_photo">
                    <span style="background-image: url(<?php echo $albums->getPhotoUrl('thumb.normal'); ?>);"></span></a>
                <?php else: ?>
                  <a href="<?php echo $this->url(array('action' => 'choose-from-albums', 'event_id' => $this->event->event_id, 'album_id' => $albums->album_id, 'format' => 'smoothbox', 'photoType' => $this->photoType), 'event_coverphoto', true); ?>" class="thumbs_photo" title="<?php echo $albums->title; ?>" >
                    <span><?php echo $this->itemPhoto($albums, 'thumb.normal'); ?></span>
                  </a>
                <?php endif; ?>
                <div class="profile_album_title">
                  <a href="<?php echo $this->url(array('action' => 'choose-from-albums', 'event_id' => $this->event->event_id, 'album_id' => $albums->album_id, 'photoType' => $this->photoType, 'format' => 'smoothbox'), 'event_coverphoto', true) ?>" title="<?php echo $albums->title; ?>"><?php echo $albums->title; ?></a>
                </div>
              </li>
            <?php endforeach; ?>
          </ul>
        </div>
      <?php else: ?>
        <div class="tip">
          <span>
            <?php echo $this->translate("No album found.") ?>
          </span>
        </div>
      <?php endif; ?>
    <?php endif; ?>
  </div>
  <div class="popup_btm fright">
    <button href="javascript:void(0);" onclick="javascript:parent.Smoothbox.close()"><?php echo $this->translate("Cancel") ?></button>
  </div>
</div>
