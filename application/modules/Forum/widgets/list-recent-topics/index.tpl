<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<div class="generic_list_wrapper">
    <ul>
      <?php foreach( $this->paginator as $topic ):
        $user = $topic->getOwner('user');
        $forum = $topic->getParent();
        ?>
        <li>
          <?php /*
          <?php echo $this->htmlLink($user->getHref(), $this->itemPhoto($user, 'thumb.icon'), array('class' => 'thumb')) ?>
           *
           */ ?>
          <div class='info'>
            <div class='name'>
              <?php echo $this->htmlLink($topic->getHref(), $topic->getTitle()) ?>
            </div>
            <div class='author'>
              <?php echo $this->translate('By') ?>
              <?php echo $this->htmlLink($user->getHref(), $this->translate($user->getTitle())) ?>
            </div>
            <div class="parent">
              <?php echo $this->translate('In') ?>
              <?php echo $this->htmlLink($forum->getHref(), $this->translate($forum->getTitle())) ?>
            </div>
            <div class='date'>
              <?php echo $this->timestamp($topic->creation_date) ?>
            </div>
          </div>
          <div class='description'>
            <?php echo $this->viewMore(strip_tags($topic->getDescription()), 64) ?>
          </div>
        </li>
      <?php endforeach; ?>
    </ul>
    
    <?php if( $this->paginator->getPages()->pageCount > 1 ): ?>
      <?php echo $this->partial('_widgetLinks.tpl', 'core', array(
        'url' => $this->url(array(), 'forum_general', true),
        )); ?>
    <?php endif; ?>
</div>
