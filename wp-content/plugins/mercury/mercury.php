<?php
/*
Plugin Name: Mercury API
*/

//[mercury]
function mercury_curl_resource( $atts ){
    $current_user = wp_get_current_user();
    $user_id = $current_user->ID;
    $post    = get_post();
    $post_id = $post->ID;

    if(!$user_id) {
        $user_id = 1;
    }

    //Path Portion
    global $wp;
    $path  = $wp->request;
    if(preg_match('/^(?:item|character)\/?$/',$path)) {
        return '';
    }
    if(preg_match('/^character(?:\/([A-Za-z][\/\w]*))?$/',$path,$matches)) {
        $path = "character/$user_id/".$matches[1];
    }

    //Query Portion
    $site_url = get_site_url();
    $query = "user_id=$user_id&post_id=$post_id&post_url_ref=$site_url:8080&callback_url_ref=$site_url";
    if(preg_match('/^item\//',$path, $matches)) {
        $query .= "&character_id=$user_id";
    }

    //URL Poriton
    $url = "http://localhost:8080/$path?$query";

    //CURL Poriton
    $curl = curl_init($url);
    if($_SERVER['REQUEST_METHOD'] === 'POST') {
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($handle, CURLOPT_POSTFIELDS, $_POST);
    }

    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $curl_response = curl_exec($curl);
    if ($curl_response === false) {
        $info = curl_getinfo($curl);
        curl_close($curl);
        die('error occured during curl exec. Additioanl info: ' . var_export($info));
    }
    curl_close($curl);

    // Return response
    //return "$url\n$curl_response";
    return $curl_response;
}
add_shortcode( 'mercury', 'mercury_curl_resource' );

add_action('init', function() {
//    add_rewrite_rule(
//        '^/character/\d+/purchase_item/\d+/?$',
//        'index.php?pagename=purchase_item',
//        'top'
//    );
    add_rewrite_rule(
        '^/item/[^/]+/?$',
        'index.php?pagename=item',
        'top'
    );
});

//function my_plugin_endpoint() {
//        add_rewrite_endpoint('action', EP_ROOT );
//}
//add_action( 'init', 'my_plugin_endpoint' )
