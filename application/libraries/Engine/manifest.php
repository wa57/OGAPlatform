<?php
/**
 * SocialEngine
 *
 * @category   Engine
 * @package    Engine
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @author     John Boehr <j@webligo.com>
 */
return array(
  'package' => array(
    'type' => 'library',
    'name' => 'engine',
    'version' => '4.10.3p1',
    'revision' => '$Revision: 10271 $',
    'path' => 'application/libraries/Engine',
    'repository' => 'socialengine.com',
    'title' => 'Engine',
    'author' => 'Webligo Developments',
    'license' => 'http://www.socialengine.com/license/',
    'dependencies' => array(
      array(
        'type' => 'core',
        'name' => 'install',
        'required' => true,
        'minVersion' => '4.1.0',
      ),
    ),
    'directories' => array(
      'application/libraries/Engine',
    )
  )
) ?>
