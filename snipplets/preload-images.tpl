{% set has_main_slider = settings.slider and settings.slider is not empty %}
{% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}
{% set has_auto_height_slider = not settings.slider_viewport_height %}
{% set use_smaller_thumbs = (has_auto_height_slider and not has_mobile_slider) or has_mobile_slider %}

{% if has_mobile_slider %}
    {% set slider = settings.slider_mobile %}
{% else %}
    {% set slider = settings.slider %}
{% endif %}


{% if settings.home_order_position_0 == 'slider' and (has_main_slider or has_mobile_slider) %}
    {% for slide in slider %}
        {% set slide_image = slide.image | static_url %}
        {% if loop.first %}
            <link rel="preload" as="image" href="{{ slide_image | settings_image_url('original') }}" imagesrcset="{% if use_smaller_thumbs %}{{ slide.image | static_url | settings_image_url('large') }} 480w, {{ slide.image | static_url | settings_image_url('huge') }} 640w, {% endif %}{{ slide_image | settings_image_url('original') }} 1024w, {{ slide_image | settings_image_url('1080p') }} 1920w">
        {% endif %}
    {% endfor %}
{% endif %}


{% set has_video = settings.video_embed %}

{% if settings.home_order_position_0 == 'video' and has_video %}
    {% if "video_image.jpg" | has_custom_image %}
        {% set video_image_src = 'video_image.jpg' | static_url | settings_image_url("original") %}
    {% else %}
        <link rel="preconnect" href="https://img.youtube.com/" />
        {% set video_url = settings.video_embed %}
        {% if '/watch?v=' in settings.video_embed %}
            {% set video_format = '/watch?v=' %}
        {% elseif '/youtu.be/' in settings.video_embed %}
            {% set video_format = '/youtu.be/' %}
        {% elseif '/shorts/' in settings.video_embed %}
            {% set video_format = '/shorts/' %}
        {% endif %}
        {% set video_id = video_url|split(video_format)|last %}
        {% set video_image_src = 'https://img.youtube.com/vi_webp/' ~ video_id ~ '/maxresdefault.webp' %}
    {% endif %}
    <link rel="preload" as="image" href="{{ video_image_src }}"{% if "video_image.jpg" | has_custom_image %} imagesrcset="{{ 'video_image.jpg' | static_url | settings_image_url('large') }} 480w, {{ 'video_image.jpg' | static_url | settings_image_url('huge') }} 640w, {{ 'video_image.jpg' | static_url | settings_image_url('original') }} 1024w"{% endif %}>
{% endif %}
