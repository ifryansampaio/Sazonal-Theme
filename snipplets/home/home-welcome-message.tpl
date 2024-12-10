<section class="section-welcome-home" data-store="home-welcome-message">
    <div class="container">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <h2 class="h1 js-welcome-message-title">{{ settings.welcome_message }}</h2>
                <p class="js-welcome-message-text" {% if not settings.welcome_text %}style="display: none"{% endif %}>{{ settings.welcome_text }}</p>
            </div>
        </div>
    </div>
</section>