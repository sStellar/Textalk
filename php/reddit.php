<?php

class RedditApi
{
  public $access_token_request;

  function __construct()
  {
    $this->api_uri = "https://www.reddit.com/api/";
    $this->state = "start";
  }

  function getTokenUri()
  {
    return "https://www.reddit.com/api/v1/authorize"
    . "?client_id=tAzrPsa8xaVZ2A&response_type=code&state=a"
    . "&redirect_uri=http://localhost:80/php/reddit.php?op=access&duration=temporary&scope=";
  }

  function initAccess($scope)
  {
    header("Location: " . $this->getTokenUri() . $scope);
  }


  function getAccessToken()
  {
    $code = $_GET['code'];
    var_dump($code);
    $this->access_token_request = curl_init($this->api_uri . "v1/access_token");
    curl_setopt($this->access_token_request, CURLOPT_POSTFIELDS, "grant_type=authorization_code&code=$code&redirect_uri=http://localhost:80/php/reddit.php");
    curl_setopt($this->access_token_request, CURLOPT_HTTPHEADER, ["Content-Type:application/x-www-form-urlencoded"]);
    curl_setopt($this->access_token_request, CURLOPT_USERPWD, "tAzrPsa8xaVZ2A" .":". "spKXYaU6SLDJEr_pbLHn7BuNaic");
    curl_setopt($this->access_token_request, CURLOPT_USERAGENT, "bot version 0.1");
    curl_exec($this->access_token_request);
  }


}

$op = isset($_GET['op']) ? $_GET['op'] : null;
$r = new RedditApi();

switch ($op) {
  case null:
    echo "this is init";
    $r->initAccess("edit");
    break;
  case "access":
    // code...
    $r->getAccessToken();
    break;
  case "after":
    echo "after";
    break;
  default:
    // code...
    echo "default";
    break;


}
