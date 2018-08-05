<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Video
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: external.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     Jung
 */
?>

<?php if( $this->error == 1 ): ?>
  <?php echo $this->translate('Embedding of videos has been disabled.') ?>
  <?php return ?>
<?php elseif( $this->error == 2 ): ?>
  <?php echo $this->translate('Embedding of videos has been disabled for this video.') ?>
  <?php return ?>
<?php elseif( !$this->video || $this->video->status != 1 ): ?>
  <?php echo $this->translate('The video you are looking for does not exist or has not been processed yet.') ?>
  <?php return ?>
<?php endif; ?>

<?php if ( $this->video->type == 'upload' && $this->video_extension == 'mp4' )
    $this->headScript()
         ->appendFile($this->layout()->staticBaseUrl . 'externals/html5media/html5media.min.js');
?>

<?php if( $this->video->type == 'upload' && $this->video_extension == 'flv' ):
    $this->headScript()
         ->appendFile($this->layout()->staticBaseUrl . 'externals/flowplayer/flowplayer-3.2.13.min.js');
  ?>
  <script type='text/javascript'>
    en4.core.runonce.add(function() {
      flashembed("video_embed", {
        src: "<?php echo $this->layout()->staticBaseUrl?>externals/flowplayer/flowplayer-3.2.18.swf",
        width: 480,
        height: 386,
        wmode: 'transparent'
      }, {
        config: {
          clip: {
            url: "<?php echo $this->video_location;?>",
            autoPlay: false,
            duration: "<?php echo $this->video->duration ?>",
            autoBuffering: true
          },
          plugins: {
            controls: {
              background: '#000000',
              bufferColor: '#333333',
              progressColor: '#444444',
              buttonColor: '#444444',
              buttonOverColor: '#666666'
            }
          },
          canvas: {
            backgroundColor:'#000000'
          }
        }
      });
    });
  </script>
<?php endif ?>

<script type="text/javascript">
  var pre_rate = <?php echo $this->video->rating;?>;
  var video_id = <?php echo $this->video->video_id;?>;
  var total_votes = <?php echo $this->rating_count;?>;
  
  function set_rating() {
    var rating = pre_rate;
    $('rating_text').innerHTML = "<?php echo $this->translate(array('%s rating', '%s ratings', $this->rating_count),$this->locale()->toNumber($this->rating_count)) ?>";
    for(var x=1; x<=parseInt(rating); x++) {
      $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big');
    }

    for(var x=parseInt(rating)+1; x<=5; x++) {
      $('rate_'+x).set('class', 'rating_star_big_generic rating_star_big_disabled');
    }

    var remainder = Math.round(rating)-rating;
    if (remainder <= 0.5 && remainder !=0){
      var last = parseInt(rating)+1;
      $('rate_'+last).set('class', 'rating_star_big_generic rating_star_big_half');
    }
  }

  en4.core.runonce.add(set_rating);
</script>

<h2>
  <?php echo $this->video->getTitle() ?>
</h2>

<div class='video_view_container' style="max-width: 500px;">

  <div class="video_view video_view_container">
    <?php if( $this->video->type == 'upload' ): ?>
    <div id="video_embed" class="video_embed">
    <?php if ($this->video_extension !== 'flv'): ?>
      <video id="video" controls preload="auto" width="480" height="386">
        <source type='video/mp4;' src="<?php echo $this->video_location ?>">
      </video>
    <?php endif ?>
    </div>
    <?php else: ?>
    <div class="video_embed">
      <?php echo $this->videoEmbedded ?>
    </div>
    <?php endif; ?>
    <div class="video_date">
      <?php echo $this->translate('Posted by %1$s on %2$s',
          $this->htmlLink($this->video->getParent(), $this->video->getParent()->getTitle()),
          $this->timestamp($this->video->creation_date)
          ) ?>
      <?php if( $this->category ): ?>
        - <?php echo $this->translate('Filed in') ?>
        <?php echo $this->htmlLink(array(
            'route' => 'video_general',
            'QUERY' => array('category' => $this->category->category_id)
          ), $this->translate($this->category->category_name)
        ) ?>
      <?php endif; ?>
      <?php if (count($this->videoTags) ): ?>
      -
        <?php foreach ($this->videoTags as $tag): ?>
          <a href='javascript:void(0);'>#<?php echo $tag->getTag()->text?></a>&nbsp;
        <?php endforeach; ?>
      <?php endif; ?>
    </div>
    <div id="video_rating" class="rating">
      <span id="rate_1" class="rating_star_big_generic"></span>
      <span id="rate_2" class="rating_star_big_generic"></span>
      <span id="rate_3" class="rating_star_big_generic"></span>
      <span id="rate_4" class="rating_star_big_generic"></span>
      <span id="rate_5" class="rating_star_big_generic"></span>
      <span id="rating_text" class="rating_text"><?php echo $this->translate('click to rate') ?></span>
    </div>
    <div class="video_desc" style="max-height: 55px;">
      <?php echo $this->video->description;?>
    </div>

    <br/>

    <?php /*
    <div class='video_options'>
      <?php if( $this->can_edit ): ?>
        <?php echo $this->htmlLink(array(
          'route' => 'default',
          'module' => 'video',
          'controller' => 'index',
          'action' => 'edit',
          'video_id' => $this->video->video_id
        ), $this->translate('Edit Video'), array(
          //'class' => 'buttonlink icon_video_edit'
        )) ?>
        &nbsp;|&nbsp;
      <?php endif;?>
      <?php if( $this->can_delete && $this->video->status != 2 ): ?>
        <?php echo $this->htmlLink(array(
          'route' => 'default',
          'module' => 'video',
          'controller' => 'index',
          'action' => 'delete',
          'video_id' => $this->video->video_id,
          'format' => 'smoothbox'
        ), $this->translate('Delete Video'), array(
          'class' => 'smoothbox'
          //'class' => 'buttonlink smoothbox icon_video_delete'
        )) ?>
        &nbsp;|&nbsp;
      <?php endif;?>
      <?php echo $this->htmlLink(array(
        'module'=> 'activity',
        'controller' => 'index',
        'action' => 'share',
        'route' => 'default',
        'type' => 'video',
        'id' => $this->video->getIdentity(),
        'format' => 'smoothbox'
      ), $this->translate("Share"), array(
        'class' => 'smoothbox'
        //'class' => 'buttonlink smoothbox icon_comments'
      )); ?>
      &nbsp;|&nbsp;
      <?php echo $this->htmlLink(array(
        'module'=> 'core',
        'controller' => 'report',
        'action' => 'create',
        'route' => 'default',
        'subject' => $this->video->getGuid(),
        'format' => 'smoothbox'
      ), $this->translate("Report"), array(
        'class' => 'smoothbox'
        //'class' => 'buttonlink smoothbox icon_report'
      )); ?>
    </div>

    <?php echo $this->action("list", "comment", "core", array("type"=>"video", "id"=>$this->video->video_id)) ?>
     * 
     */ ?>
  </div>

</div>