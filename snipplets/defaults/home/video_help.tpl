{# Video that work as examples #}

<div class="container-fluid p-0 js-home-video-placeholder">
	<div class="row no-gutters">
		<div class="col-12 text-center">
			<h2 class="h1">{{ "Video" | translate }}</h2>
			<div class="js-video-home embed-responsive embed-responsive-16by9">
				<div class="js-play-button video-player">
					<div class="video-player-icon">
						<svg class="icon-inline icon-lg ml-2 svg-icon-invert"><use xlink:href="#play"/></svg>
					</div>
				</div>
				<svg viewBox="0 0 1130 635.63"><use xlink:href="#video-placeholder"/></svg>
				<div class="placeholder-overlay transition-soft">
				<div class="placeholder-info">
						<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
						<div class="placeholder-description font-small-xs">
							{{ "Podés subir tu video de YouTube o Vimeo desde" | translate }} <strong>"{{ "Video" | translate }}"</strong>
						</div>
						{% if not params.preview %}
							<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
						{% endif %}
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-home-video-top" style="display:none">
	{% include 'snipplets/home/home-video.tpl' %}
</div>