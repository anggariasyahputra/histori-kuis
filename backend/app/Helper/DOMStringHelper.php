<?php

namespace App\Helper;

use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;

class DOMStringHelper
{
    const MAX_WIDTH = 1440;
    const MAX_HEIGHT = 1440;
    const MAX_FILE_SIZE = 2 * 1024 * 1024; // 2MB
    /**
     * Save all base64 images, replace base64 url with image path
     */
    public static function processImagesFromDOM(string $html_string)
    {
        // Check if GD extension is loaded
        if (!extension_loaded('gd')) {
            \Log::warning('GD extension is not loaded. Image processing will be skipped.');
            return $html_string;
        }

        libxml_use_internal_errors(true);
        $html_string = mb_convert_encoding($html_string, 'UTF-8', 'auto');
        $dom = new \DOMDocument();
        @$dom->loadHTML(mb_convert_encoding($html_string, 'HTML-ENTITIES', 'UTF-8'), LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        libxml_clear_errors();
        $images = $dom->getElementsByTagName('img');

        foreach ($images as $img) {
            try {
                $src = $img->attributes['src']->textContent;

                if (preg_match('/^data:image\/(\w+);base64,/', $src, $matches)) {
                    $image_data = substr($src, strpos($src, ',') + 1);
                    $decoded_image = base64_decode($image_data);

                    if (strlen($decoded_image) > self::MAX_FILE_SIZE) {
                        continue;
                    }

                    // Check if imagecreatefromstring function exists
                    if (!function_exists('imagecreatefromstring')) {
                        \Log::warning('imagecreatefromstring function not available. Skipping image processing.');
                        continue;
                    }

                    $image = imagecreatefromstring($decoded_image);

                    if (!$image) {
                        \Log::warning('Failed to create image from string data.');
                        continue;
                    }

                    $width = imagesx($image);
                    $height = imagesy($image);
                    $new_width = $width;
                    $new_height = $height;

                    if ($width > self::MAX_WIDTH || $height > self::MAX_HEIGHT) {
                        if ($width >= $height) {
                            $new_width = self::MAX_WIDTH;
                            $new_height = intval(($height / $width) * self::MAX_WIDTH);
                        } else {
                            $new_height = self::MAX_HEIGHT;
                            $new_width = intval(($width / $height) * self::MAX_HEIGHT);
                        }
                        $resized_image = imagecreatetruecolor($new_width, $new_height);
                        
                        if (!$resized_image) {
                            \Log::warning('Failed to create resized image.');
                            imagedestroy($image);
                            continue;
                        }
                        
                        imagecopyresampled($resized_image, $image, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
                        imagedestroy($image);
                        $image = $resized_image;
                    }
                    
                    $image_name = (string) Str::uuid() . '-' . time() . '.' . $matches[1] . '.webp';
                    $image_path = '' . $image_name;

                    // Check if imagewebp function exists
                    if (!function_exists('imagewebp')) {
                        \Log::warning('imagewebp function not available. Using JPEG format instead.');
                        $image_name = (string) Str::uuid() . '-' . time() . '.jpg';
                        $image_path = '' . $image_name;
                        
                        ob_start();
                        imagejpeg($image, null, 85);
                        $image_content = ob_get_clean();
                    } else {
                        // imagewebp function not return value, use ob_start to capture the image
                        ob_start();
                        imagewebp($image, null);
                        $image_content = ob_get_clean();
                    }
                    
                    Storage::put($image_path, $image_content);

                    imagedestroy($image);
                    unset($decoded_image, $resized_image, $image_content);

                    $img->attributes['src']->textContent = "/uploads/$image_name";
                }
            } catch (\Exception $e) {
                \Log::error('Error processing image: ' . $e->getMessage());
                continue;
            }
        }
        return $dom->saveHTML();
    }
}
