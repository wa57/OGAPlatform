<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Music
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: index.tpl 9916 2013-02-15 03:13:27Z alex $
 * @author     Steve
 */
?>

<script type="text/javascript">

function multiDelete()
{
  return confirm("<?php echo $this->translate('Are you sure you want to delete the selected playlists?');?>");
}

function selectAll()
{
  var i;
  var multidelete_form = $('multidelete_form');
  var inputs = multidelete_form.elements;
  for (i = 1; i < inputs.length; i++) {
    if (!inputs[i].disabled) {
      inputs[i].checked = inputs[0].checked;
    }
  }
}
</script>

<h2><?php echo $this->translate("Music Plugin") ?></h2>


<?php if( count($this->navigation) ): ?>
  <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
  </div>
<?php endif; ?>

<br />

<?php
$settings = Engine_Api::_()->getApi('settings', 'core');
if( $settings->getSetting('user.support.links', 0) == 1 ) {
	echo 'More info on the Music Plugin: <a href="http://support.socialengine.com/questions/190/Admin-Panel-Plugins-Music" target="_blank">See KB article</a>.<br />';	
} 
?>	

<?php if( count($this->paginator) ): ?>
  <form id='multidelete_form' method="post" action="<?php echo $this->url();?>" onSubmit="return multiDelete()">
  <table class='admin_table'>
    <thead>
      <tr>
        <th class='admin_table_short'><input onclick='selectAll();' type='checkbox' class='checkbox' /></th>
        <th class='admin_table_short'>ID</th>
        <th><?php echo $this->translate("Title") ?></th>
        <th><?php echo $this->translate("Owner") ?></th>
        <th><?php echo $this->translate("Songs") ?></th>
        <th><?php echo $this->translate("Plays") ?></th>
        <th><?php echo $this->translate("Date") ?></th>
        <th><?php echo $this->translate("Options") ?></th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($this->paginator as $item): ?>
        <tr>
          <td><input type='checkbox' class='checkbox' name='delete_<?php echo $item->getIdentity(); ?>' value="<?php echo $item->getIdentity(); ?>" /></td>
          <td><?php echo $item->getIdentity() ?></td>
          <td><?php echo $item->getTitle() ?></td>
          <td><?php echo $item->getOwner()->getTitle() ?></td>
          <td><?php echo count($item->getSongs()) ?>
          <td><?php echo $this->locale()->toNumber($item->play_count) ?></td>
          <td><?php echo $item->creation_date ?></td>
          <td>
            <?php echo $this->htmlLink($item->getHref(), 'play') ?>
            |
            <?php echo $this->htmlLink(
                array('route' => 'default', 'module' => 'music', 'controller' => 'admin-manage', 'action' => 'delete', 'id' => $item->getIdentity()),
                $this->translate("delete"),
                array('class' => 'smoothbox')) ?>
          </td>
        </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
    <br />

    <div class='buttons'>
      <button type='submit'><?php echo $this->translate("Delete Selected") ?></button>
    </div>
  </form>

  <br />
  <div>
    <?php echo $this->paginationControl($this->paginator); ?>
  </div>

<?php else: ?>
  <br />
  <div class="tip">
    <span>
      <?php echo $this->translate("There are no songs posted by your members yet.") ?>
    </span>
  </div>
<?php endif; ?>
