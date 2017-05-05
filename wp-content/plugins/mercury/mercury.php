<?php
/*
Plugin Name: Mercury API
*/

//[mercury]
function mercury_func( $atts ){
    $a = shortcode_atts( array(
        'path' => '/items',
    ), $atts );

    //$current_user = wp_get_current_user();
    //$user_id = $current_user->ID;
    //$post    = get_post();
    //$post_id = $post->ID;

    global $wp;
    $url = "http://localhost:8080";
    if($a['path'] == '/item') {
        $path =  $wp->request;
        $url = "$url/$path";
    }
    else {
        $url = $url.$a['path'];
    }

    $curl = curl_init($url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $curl_response = curl_exec($curl);
    if ($curl_response === false) {
        $info = curl_getinfo($curl);
        curl_close($curl);
        die('error occured during curl exec. Additioanl info: ' . var_export($info));
    }
    curl_close($curl);
    return $curl_response;
}
add_shortcode( 'mercury', 'mercury_func' );

add_action('init', function() {
    $item_page_id = 49; // update 2 (sample page) to your custom page ID where you can get the subscriber(s) data later
    $page_data = get_post($item_page_id);
 
    if( ! is_object($page_data) ) { // post not there
        return;
    }
 
    add_rewrite_rule(
        $page_data->post_name . '/[^/]+/?$',
        'index.php?pagename=' . $page_data->post_name,
        'top'
    );
 
});

