<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: index.tpl 9751 2012-08-03 22:18:52Z richard $
 * @author     Jung
 */
?>

<h2>
    <?php echo $this->translate("Theme Editor") ?>
</h2>
<?php
$settings = Engine_Api::_()->getApi('settings', 'core');
if ($settings->getSetting('user.support.links', 0) == 1) {
    echo 'More info: <a href="http://support.socialengine.com/php/customer/portal/articles/2766327-theme-editor-updated?b_id=4311" target="_blank">See KB article</a>';
}
?>
<br />

<script type="text/javascript">
    var modifications = [];
    window.onbeforeunload = function() {
        if( modifications.length > 0 ) {
            return '<?php echo $this->translate("If you leave the page now, your changes will be lost. Are you sure you want to continue?") ?>';
        }
    }
    var pushModification = function(type) {
        modifications.push(type);
    }
    var removeModification = function(type) {
        modifications.erase(type);
    }
    var changeThemeFile = function(file) {
        var url = '<?php echo $this->url() ?>?file=' + file;
        window.location.href = url;
    }
    var saveFileChanges = function() {
        var request = new Request.JSON({
            url : '<?php echo $this->url(array('action' => 'save')) ?>',
            data : {
                'theme_id' : $('theme_id').value,
                'file' : $('file').value,
                'body' : $('body').value,
                'format' : 'json'
            },
            onComplete : function(responseJSON) {
                if( responseJSON.status ) {
                    removeModification('body');
                    $$('.admin_themes_header_revert').setStyle('display', 'inline');
                    alert('<?php echo $this->string()->escapeJavascript($this->translate("Your changes have been saved!")) ?>');
                } else {
                    alert('<?php echo $this->string()->escapeJavascript($this->translate("An error has occurred. Changes could NOT be saved.")) ?>');
                }
            }
        });
        request.send();
    }
    var revertThemeFile = function() {
        var answer = confirm('<?php echo $this->string()->escapeJavascript($this->translate("CORE_VIEWS_SCRIPTS_ADMINTHEMES_INDEX_REVERTTHEMEFILE")) ?>');
        if( !answer ) {
            return;
        }

        var request = new Request.JSON({
            url : '<?php echo $this->url(array('action' => 'revert')) ?>',
            data : {
                'theme_id' : '<?php echo $this->activeTheme->theme_id ?>',
                'format' : 'json'
            },
            onComplete : function() {
                removeModification('body');
                window.location.replace( window.location.href );
            }
        });
        request.send();
    }
</script>


<div class="admin_theme_editor_wrapper">
    <form action="<?php echo $this->url(array('action' => 'save')) ?>" method="post">
        <div class="admin_theme_edit">

            <div class="admin_theme_header_controls">
                <h3>
                    <?php echo $this->translate('Active Theme') ?>
                </h3>
                <div>
                    <?php if (!empty($this->manifest[$this->activeTheme->name]['colorVariants'])): ?>
                        <?php echo $this->htmlLink(
                            array('route'=>'admin_default', 'controller'=>'themes', 'action'=>'create-color-variant', 'name' => $this->activeTheme->name),
                            $this->translate('Color Variants'), array(
                            'class' => 'buttonlink admin_themes_header_customize',
                        ));
                        ?>
                    <?php endif; ?>
                    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Revert'), array(
                        'class' => 'buttonlink admin_themes_header_revert',
                        'onclick' => 'revertThemeFile();',
                        'style' => !empty($this->modified[$this->activeTheme->name]) ? '':'display:none;')) ?>
                    <?php echo $this->htmlLink(array('route'=>'admin_default', 'controller'=>'themes', 'action'=>'export','name'=>$this->activeTheme->name),
                        $this->translate('Export'), array(
                            'class' => 'buttonlink admin_themes_header_export',
                        )) ?>
                    <?php echo $this->htmlLink(array('route'=>'admin_default', 'controller'=>'themes', 'action'=>'clone', 'name'=>$this->activeTheme->name),
                        $this->translate('Clone'), array(
                            'class' => 'buttonlink admin_themes_header_clone',
                        )) ?>
                    <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Save Changes'), array(
                        'onclick' => 'saveFileChanges();return false;',
                        'class' => 'buttonlink admin_themes_header_save',
                    )) ?>
                </div>
            </div>


            <?php if ($this->writeable[$this->activeTheme->name]): ?>
                <div class="admin_theme_editor_edit_wrapper">

                    <div class="admin_theme_editor_selected">
                        <?php foreach ($this->themes as $theme):?>
                            <?php
                            // @todo meta key is deprecated and pending removal in 4.1.0; b/c removal in 4.2.0
                            $thumb = $this->layout()->staticBaseUrl . 'application/modules/Core/externals/images/anonymous.png';
                            if (!empty($this->manifest[$theme->name]['package']['thumb'])) {
                                $thumb = $this->manifest[$theme->name]['package']['thumb'];
                            }
                            if ($theme->name === $this->activeTheme->name): ?>
                                <div class="theme_wrapper_selected"><img src="<?php echo $thumb ?>" alt="<?php echo $theme->name?>"></div>
                                <div class="theme_selected_info">
                                    <h3><?php echo $theme->title?></h3>
                                    <?php if (!empty($this->manifest[$theme->name]['package']['version'])): ?>
                                        <h4 class="version">v<?php echo $this->manifest[$theme->name]['package']['version'] ?></h4>
                                    <?php endif; ?>
                                    <?php if (!empty($this->manifest[$theme->name]['package']['author'])): ?>
                                        <h4><?php echo $this->translate('by %s', $this->manifest[$theme->name]['package']['author']) ?></h4>
                                    <?php endif; ?>
                                    <div class="theme_edit_file">
                                        <h4>
                                            <?php echo $this->translate("Editing File:") ?>
                                        </h4>
                                        <?php echo $this->formSelect('choosefile', $this->activeFileName, array('onchange' => 'changeThemeFile(this.value);'), $this->activeFileOptions) ?>
                                    </div>
                                </div>
                                <?php break; endif; ?>
                        <?php endforeach; ?>
                    </div>

                    <div class="admin_theme_editor">
                        <?php echo $this->formTextarea('body', $this->activeFileContents, array('onkeypress' => 'pushModification("body")', 'spellcheck' => 'false')) ?>
                    </div>
                    <button class="activate_button" type="submit" onclick="saveFileChanges();return false;"><?php echo $this->translate("Save Changes") ?></button>

                    <?php echo $this->formHidden('file', $this->activeFileName, array()) ?>
                    <?php echo $this->formHidden('theme_id', $this->activeTheme->theme_id, array()) ?>

                </div>
            <?php else: ?>
                <div class="admin_theme_editor_edit_wrapper">
                    <div class="tip">
            <span>

              <?php echo $this->translate('CORE_VIEWS_SCRIPTS_ADMINTHEMES_INDEX_STYLESHEETSPERMISSION', $this->activeTheme->name) ?>

            </span>
                    </div>
                </div>
            <?php endif; ?>
        </div>
    </form>


    <div class="admin_theme_chooser">

        <div class="admin_theme_header_controls">
            <h3>
                <?php echo $this->translate("Available Themes") ?>
            </h3>
            <div>
                <?php echo $this->htmlLink(array('route'=>'admin_default', 'controller'=>'themes','action'=>'upload'), $this->translate("Upload New Theme"), array('class'=>'buttonlink admin_themes_header_import')) ?>
                <!--
                <a class="admin help" href="http://support.socialengine.com/questions/128/Creating-Your-Own-Theme" target="_blank" style="margin-left: 10px; margin-right: 0px;"> </a>
                -->
            </div>
        </div>


        <div class="admin_theme_editor_chooser_wrapper">
            <ul class="admin_themes">
                <?php
                // @todo meta key is deprecated and pending removal in 4.1.0; b/c removal in 4.2.0
                $alt_row = true;
                foreach ($this->themes as $theme):
                    $thumb = $this->layout()->staticBaseUrl . 'application/modules/Core/externals/images/anonymous.png';
                    if (!empty($this->manifest[$theme->name]['package']['thumb'])) {
                        $thumb = $this->manifest[$theme->name]['package']['thumb'];
                    }
                    ?>
                    <li <?php echo ($alt_row) ? ' class="alt_row"' : "";?>>
                        <div class="theme_wrapper">
                            <img src="<?php echo $thumb ?>" alt="<?php echo $theme->name?>">

                            <?php if ($theme->name !== $this->activeTheme->name):?>
                                <a href="<?php echo $this->url(array('action' => 'delete', 'name' => $theme->name)); ?>" class="delete-theme smoothbox">
                                    <i class="fa fa-times" aria-hidden="true"></i>
                                </a>
                            <?php endif; ?>
                        </div>
                        <div class="theme_chooser_info">
                            <h3><?php echo $theme->title?></h3>
                            <?php if (!empty($this->manifest[$theme->name]['package']['version'])): ?>
                                <h4 class="version">v<?php echo $this->manifest[$theme->name]['package']['version'] ?></h4>
                            <?php endif; ?>
                            <?php if (!empty($this->manifest[$theme->name]['package']['author'])): ?>
                                <h4><?php echo $this->translate('by %s', $this->manifest[$theme->name]['package']['author']) ?></h4>
                            <?php endif; ?>
                            <?php if ($theme->name !== $this->activeTheme->name):?>
                                <form action="<?php echo $this->url(array('action' => 'change')) ?>" method="post">
                                    <button type="submit" class="activate_button"><?php echo $this->translate('Activate Theme') ?></button>
                                    <?php echo $this->formHidden('theme', $theme->name, array('id'=>'')) ?>
                                </form>
                            <?php else:?>
                                <div class="current_theme">
                                    (<?php echo $this->translate("this is your current theme") ?>)
                                </div>
                            <?php endif;?>

                            <?php if (isset($this->colorVariants[$theme->name])): ?>
                                <?php $versionCompare = version_compare($this->colorVariants[$theme->name]['version'], $this->manifest[$theme->name]['package']['version']); ?>
                                <?php if (array_key_exists($theme->name, $this->colorVariants) &&  $versionCompare > 0): ?>
                                    <?php echo $this->htmlLink(
                                        array('reset' => false, 'action' => 'upgrade-color-variant', 'name' => $this->colorVariants[$theme->name]['parentTheme'],
                                            'colorVariantName' => $theme->name),
                                        '<button class="upgrade_theme_button">' . $this->translate('Upgrade Theme') . ' (v' . $this->colorVariants[$theme->name]['version'] . ')</button>',
                                        array('class' => 'smoothbox')
                                    ) ?>
                                <?php endif; ?>
                            <?php endif; ?>

                            <?php if (!empty($this->manifest[$theme->name]['colorVariants'])): ?>
                                <?php echo $this->htmlLink(
                                    array('route'=>'admin_default', 'controller'=>'themes', 'action'=>'create-color-variant', 'name' => $theme->name),
                                    '<button class="upgrade_theme_button">' . $this->translate('Color Variants') . '</button>'
                                ) ?>
                            <?php endif;?>
                        </div>
                    </li>
                    <?php $alt_row = !$alt_row; ?>
                <?php endforeach; ?>
            </ul>
        </div>

    </div>

</div>

<script type="text/javascript">
    //<![CDATA[
    var updateCloneLink = function(){
        var value = $$('.theme_name input:checked');
        if (!value)
            return;
        else
            var newValue = value[0].value;
        var link = $$('a.admin_themes_header_clone');
        if (link.length) {
            link.set('href', link[0].href.replace(/\/name\/[^\/]+/, '/name/'+newValue));
        }
    }
    //]]>
</script>
