<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Video
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: index.tpl 9859 2013-02-12 02:06:55Z john $
 * @author     Jung
 */
?>

<?php $uid = md5(time() . rand(1, 1000)) ?>

<script type="text/javascript">
  en4.core.runonce.add(function(){
    var uid = '<?php echo $uid ?>';
    var hasTitle = Boolean($$('.profile_videos_' + uid)[0].getParent().getElement('h3'));
    
    <?php if( !$this->renderOne ): ?>
    var anchor = $$('.profile_videos_' + uid)[0].getParent();
    $$('.profile_videos_previous_' + uid)[0].style.display = '<?php echo ( $this->paginator->getCurrentPageNumber() == 1 ? 'none' : '' ) ?>';
    $$('.profile_videos_next_' + uid)[0].style.display = '<?php echo ( $this->paginator->count() == $this->paginator->getCurrentPageNumber() ? 'none' : '' ) ?>';

    $$('.profile_videos_previous_' + uid)[0].removeEvents('click').addEvent('click', function(){
      en4.core.request.send(new Request.HTML({
        url : en4.core.baseUrl + 'widget/index/content_id/' + <?php echo sprintf('%d', $this->identity) ?>,
        data : {
          format : 'html',
          subject : en4.core.subject.guid,
          page : <?php echo sprintf('%d', $this->paginator->getCurrentPageNumber() - 1) ?>
        }
      }), {
        'element' : anchor
      })
    });

    $$('.profile_videos_next_' + uid)[0].removeEvents('click').addEvent('click', function(){
      en4.core.request.send(new Request.HTML({
        url : en4.core.baseUrl + 'widget/index/content_id/' + <?php echo sprintf('%d', $this->identity) ?>,
        data : {
          format : 'html',
          subject : en4.core.subject.guid,
          page : <?php echo sprintf('%d', $this->paginator->getCurrentPageNumber() + 1) ?>
        }
      }), {
        'element' : anchor
      })
      en4.core.runonce.add(function() {
        if( !hasTitle ) {
          anchor.getElement('h3').destroy();
        }
      });
    });
    <?php endif; ?>
  });
</script>

<ul id="profile_videos" class="videos_browse profile_videos_<?php echo $uid ?>">
  <?php foreach( $this->paginator as $item ): ?>
    <li>
      <div class="video_thumb_wrapper">
        <?php if ($item->duration):?>
        <span class="video_length">
          <?php
            if( $item->duration>360 ) $duration = gmdate("H:i:s", $item->duration); else $duration = gmdate("i:s", $item->duration);
            if ($duration[0] =='0') $duration = substr($duration,1); echo $duration;
          ?>
        </span>
        <?php endif;?>
        <?php echo $this->htmlLink($item->getHref(), $this->itemBackgroundPhoto($item, 'thumb.normal')); ?>
      </div>
      <a class="video_title" href='<?php echo $item->getHref();?>'><?php echo $item->getTitle();?></a>
      <div class="video_author"><?php echo $this->translate('By');?> <?php echo $this->htmlLink($item->getOwner()->getHref(), $item->getOwner()->getTitle()) ?></div>
      <div class="video_stats">
        <span class="video_views"><?php echo $item->view_count;?> <?php echo $this->translate('views');?></span>
        <?php if($item->rating>0):?>
          <?php for($x=1; $x<=$item->rating; $x++): ?><span class="rating_star_generic rating_star"></span><?php endfor; ?><?php if((round($item->rating)-$item->rating)>0):?><span class="rating_star_generic rating_star_half"></span><?php endif; ?>
        <?php endif; ?>
      </div>
    </li>
  <?php endforeach; ?>
</ul>

<div>
  <div id="profile_videos_previous" class="paginator_previous profile_videos_previous_<?php echo $uid ?>">
    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Previous'), array(
      'onclick' => '',
      'class' => 'buttonlink icon_previous'
    )); ?>
  </div>
  <div id="profile_videos_next" class="paginator_next profile_videos_next_<?php echo $uid ?>">
    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Next'), array(
      'onclick' => '',
      'class' => 'buttonlink_right icon_next'
    )); ?>
  </div>
</div>
