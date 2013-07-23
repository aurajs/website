/* Load this script using conditional IE comments if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'icomoon\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-stackoverflow' : '&#xe000;',
			'icon-github' : '&#xe001;',
			'icon-firefox' : '&#xe002;',
			'icon-IE' : '&#xe003;',
			'icon-chrome' : '&#xe004;',
			'icon-css3' : '&#xe005;',
			'icon-html5' : '&#xe006;',
			'icon-html5-2' : '&#xe007;',
			'icon-file-css' : '&#xe008;',
			'icon-file-xml' : '&#xe009;',
			'icon-safari' : '&#xe00a;',
			'icon-opera' : '&#xe00b;',
			'icon-new-tab' : '&#xe00c;',
			'icon-checkmark-circle' : '&#xe00d;',
			'icon-cancel-circle' : '&#xe00e;',
			'icon-info' : '&#xe00f;',
			'icon-notification' : '&#xe010;',
			'icon-brightness-medium' : '&#xe011;',
			'icon-lightning' : '&#xe012;',
			'icon-globe' : '&#xe013;',
			'icon-dashboard' : '&#xe014;',
			'icon-podcast' : '&#xe015;',
			'icon-file' : '&#xe016;',
			'icon-copy' : '&#xe017;',
			'icon-screen' : '&#xe018;',
			'icon-mobile' : '&#xe019;',
			'icon-mobile-2' : '&#xe01a;',
			'icon-tablet' : '&#xe01b;',
			'icon-tv' : '&#xe01c;',
			'icon-download' : '&#xe01d;',
			'icon-upload' : '&#xe01e;',
			'icon-cog' : '&#xe01f;',
			'icon-cogs' : '&#xe020;',
			'icon-wrench' : '&#xe021;',
			'icon-hammer' : '&#xe022;',
			'icon-wand' : '&#xe023;',
			'icon-gift' : '&#xe024;',
			'icon-rocket' : '&#xe025;',
			'icon-fire' : '&#xe026;',
			'icon-lab' : '&#xe027;',
			'icon-tree' : '&#xe029;',
			'icon-power-cord' : '&#xe02a;',
			'icon-link' : '&#xe028;',
			'icon-bookmark' : '&#xe02b;',
			'icon-insert-template' : '&#xe02c;',
			'icon-embed' : '&#xe02d;',
			'icon-code' : '&#xe02e;',
			'icon-console' : '&#xe02f;',
			'icon-mail' : '&#xe030;',
			'icon-twitter' : '&#xe031;',
			'icon-facebook' : '&#xe032;',
			'icon-database' : '&#xe033;',
			'icon-atom' : '&#xe034;',
			'icon-code-2' : '&#xe035;',
			'icon-fork' : '&#xe036;',
			'icon-chat-alt-stroke' : '&#xe037;',
			'icon-chat-alt-fill' : '&#xe038;',
			'icon-mail-2' : '&#xe039;',
			'icon-menu' : '&#xe03a;',
			'icon-cloud' : '&#xe03b;',
			'icon-briefcase' : '&#xe03c;',
			'icon-angle-left' : '&#xf104;',
			'icon-angle-right' : '&#xf105;',
			'icon-angle-up' : '&#xf106;',
			'icon-angle-down' : '&#xf107;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, html, c, el;
	for (i = 0; ; i += 1) {
		el = els[i];
		if(!el) {
			break;
		}
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/icon-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};