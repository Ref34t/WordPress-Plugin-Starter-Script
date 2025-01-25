#!/bin/bash

# Set default values
DEFAULT_PLUGIN_NAME="My Plugin"
DEFAULT_PLUGIN_DESCRIPTION="A brief description of the plugin."
DEFAULT_PLUGIN_VERSION="1.0.0"
DEFAULT_PLUGIN_AUTHOR="Your Name"
DEFAULT_PLUGIN_AUTHOR_URI="https://yourwebsite.com"
DEFAULT_PLUGIN_LICENSE="GPLv2"

# Prompt for plugin details with default values
read -p "Enter Plugin Name [$DEFAULT_PLUGIN_NAME]: " PLUGIN_NAME
PLUGIN_NAME=${PLUGIN_NAME:-$DEFAULT_PLUGIN_NAME}

read -p "Enter Plugin Description [$DEFAULT_PLUGIN_DESCRIPTION]: " PLUGIN_DESCRIPTION
PLUGIN_DESCRIPTION=${PLUGIN_DESCRIPTION:-$DEFAULT_PLUGIN_DESCRIPTION}

read -p "Enter Plugin Version [$DEFAULT_PLUGIN_VERSION]: " PLUGIN_VERSION
PLUGIN_VERSION=${PLUGIN_VERSION:-$DEFAULT_PLUGIN_VERSION}

read -p "Enter Plugin Author [$DEFAULT_PLUGIN_AUTHOR]: " PLUGIN_AUTHOR
PLUGIN_AUTHOR=${PLUGIN_AUTHOR:-$DEFAULT_PLUGIN_AUTHOR}

read -p "Enter Author URI [$DEFAULT_PLUGIN_AUTHOR_URI]: " PLUGIN_AUTHOR_URI
PLUGIN_AUTHOR_URI=${PLUGIN_AUTHOR_URI:-$DEFAULT_PLUGIN_AUTHOR_URI}

read -p "Enter Plugin License [$DEFAULT_PLUGIN_LICENSE]: " PLUGIN_LICENSE
PLUGIN_LICENSE=${PLUGIN_LICENSE:-$DEFAULT_PLUGIN_LICENSE}

# Generate the plugin slug
PLUGIN_SLUG=$(echo "$PLUGIN_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Define the WordPress plugins directory (change this if needed)
WP_PLUGINS_DIR="../"

# Create the plugin directory
PLUGIN_DIR="$WP_PLUGINS_DIR/$PLUGIN_SLUG"
mkdir -p "$PLUGIN_DIR"
echo "Creating plugin directory at: $PLUGIN_DIR"

# Create the main plugin file
PLUGIN_FILE="$PLUGIN_DIR/$PLUGIN_SLUG.php"

# Write the PHP code to the plugin file
cat <<EOL > "$PLUGIN_FILE"
<?php
/**
 * Plugin Name:       $PLUGIN_NAME
 * Plugin URI:        $PLUGIN_AUTHOR_URI
 * Description:       $PLUGIN_DESCRIPTION
 * Version:           $PLUGIN_VERSION
 * Author:            $PLUGIN_AUTHOR
 * Author URI:        $PLUGIN_AUTHOR_URI
 * License:           $PLUGIN_LICENSE
 * Requires PHP:      7.4
 * Requires at least: 5.7
 */

// Define constants
define( 'MY_PLUGIN_VERSION', '$PLUGIN_VERSION' );
define( 'MY_PLUGIN_URL', plugin_dir_url( __FILE__ ) );
define('MY_PLUGIN_NAME', '$PLUGIN_NAME');

// Exit if accessed directly
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

/**
 * Activation hook
 */
function my_plugin_activate() {
    // Activation code here
}
register_activation_hook( __FILE__, 'my_plugin_activate' );

/**
 * Deactivation hook
 */
function my_plugin_deactivate() {
    // Deactivation code here
}
register_deactivation_hook( __FILE__, 'my_plugin_deactivate' );

/**
 * Enqueue assets
 */
function my_plugin_enqueue_assets() {
    wp_enqueue_style( 'my-plugin-style', MY_PLUGIN_URL . 'assets/css/style.css', array(), MY_PLUGIN_VERSION );
    wp_enqueue_script( 'my-plugin-script', MY_PLUGIN_URL . 'assets/js/script.js', array( 'jquery' ), MY_PLUGIN_VERSION, true );
}
add_action( 'wp_enqueue_scripts', 'my_plugin_enqueue_assets' );

/**
 * Add shortcode
 */
function my_plugin_shortcode() {
    return '<p>This is a shortcode output from ' . MY_PLUGIN_NAME . ' plugin.</p>';
}
add_shortcode( 'my_plugin_shortcode', 'my_plugin_shortcode' );
EOL

echo "Plugin file created at: $PLUGIN_FILE"

# Create subdirectories
mkdir -p "$PLUGIN_DIR/includes"
mkdir -p "$PLUGIN_DIR/assets/css"
mkdir -p "$PLUGIN_DIR/assets/js"
mkdir -p "$PLUGIN_DIR/assets/images"

# Create a default CSS file
echo "/* Add your plugin styles here */" > "$PLUGIN_DIR/assets/css/style.css"

# Create a default JS file
echo "// Add your plugin scripts here" > "$PLUGIN_DIR/assets/js/script.js"

# Create a readme.txt file
cat <<EOL > "$PLUGIN_DIR/readme.txt"
=== ${PLUGIN_NAME} ===
Contributors: ${PLUGIN_AUTHOR}
Requires at least: 5.7
Tested up to: 6.3
Requires PHP: 7.4
License: ${PLUGIN_LICENSE}
License URI: https://www.gnu.org/licenses/gpl-2.0.html

${PLUGIN_DESCRIPTION}
EOL

# Create composer.json file
cat <<EOF > "$PLUGIN_DIR/composer.json"
{
    "name": "${PLUGIN_AUTHOR}/${PLUGIN_SLUG}",
    "description": "${PLUGIN_DESCRIPTION}",
    "type": "wordpress-plugin",
    "license": "${PLUGIN_LICENSE}",
    "require": {
        "php": ">=7.4"
    },
    "autoload": {
        "psr-4": {
            "$(echo "$PLUGIN_SLUG" | sed -E 's/(^|-)([a-z])/\U\2/g')\\": "includes/"
        }
    }
}
EOF

# Output success message
echo "Plugin starter structure created in ${PLUGIN_SLUG}!"