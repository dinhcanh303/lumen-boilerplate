<?php

namespace Utils;

use Constant\Constant;
use Illuminate\Http\Request;

class User {
    public static function InfoUserFromHeader(Request $request){
        $header = $request->header(Constant::X_AUTH_USER);
        if($header){
            $userInfo = explode(",",$header);
            if(count($userInfo) == 5){
                return [
                    "id" => $userInfo[0],
                    "email" => $userInfo[1],
                    "name" => $userInfo[2],
                    "role" => $userInfo[3],
                    "avatar_url" => $userInfo[4]
                ];
            }
        }
        return null;
    }
}