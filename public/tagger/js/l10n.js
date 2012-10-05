/*  Copyright (c) 2011-2012 Fabien Cazenave, Mozilla.
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to
  * deal in the Software without restriction, including without limitation the
  * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  * sell copies of the Software, and to permit persons to whom the Software is
  * furnished to do so, subject to the following conditions:
  *
  * The above copyright notice and this permission notice shall be included in
  * all copies or substantial portions of the Software.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  * IN THE SOFTWARE.
  *//*
  Additional modifications for PDF.js project:
    - Loading resources from <script type='application/l10n'>;
    - Disabling language initialization on page loading;
    - Add fallback argument to the translateString.
*/"use strict";(function(e){function i(e){return e.replace(/\\\\/g,"\\").replace(/\\n/g,"\n").replace(/\\r/g,"\r").replace(/\\t/g,"	").replace(/\\b/g,"\b").replace(/\\f/g,"\f").replace(/\\{/g,"{").replace(/\\}/g,"}").replace(/\\"/g,'"').replace(/\\'/g,"'")}function s(e,n){var r=/^\s*|\s*$/,s=/^\s*#|^\s*$/,o=/^\s*\[(.*)\]\s*$/,u=/^\s*@import\s+url\((.*)\)\s*$/i,a="*",f=[],l=!1,c=[],h="",p=e.replace(r,"").split(/[\r\n]+/);for(var d=0;d<p.length;d++){var v=p[d];if(s.test(v))continue;if(o.test(v)){h=o.exec(v),a=h[1],l=a!=n&&a!="*"&&a!=n.substring(0,2);continue}if(l)continue;u.test(v)&&(h=u.exec(v));var m=v.split("=");m.length>1&&(c[m[0]]=i(m[1]))}for(var g in c){var y,b,w=g.lastIndexOf(".");w>0?(y=g.substring(0,w),b=g.substr(w+1)):(y=g,b="textContent"),t[y]||(t[y]={}),t[y][b]=c[g]}}function o(e,t){return n+=e,s(e,t)}function u(e,t,n,r){var i=new XMLHttpRequest;i.open("GET",e,!0),i.overrideMimeType("text/plain; charset=utf-8"),i.onreadystatechange=function(){i.readyState==4&&(i.status==200||i.status==0?(o(i.responseText,t),n&&n()):r&&r())},i.send(null)}function a(t,n){function p(e){var t=e.href,n=e.type;this.load=function(e,n){var r=e;return u(t,e,n,function(){console.warn(t+" not found."),r=""}),r}}d();var i=document.querySelectorAll('link[type="application/l10n"]'),s=i.length,a=document.querySelectorAll('script[type="application/l10n"]'),f=a.length,l=s+f,c=null,h=0;c=function(){h++;if(h>=l){n&&n();var r=document.createEvent("Event");r.initEvent("localized",!1,!1),r.language=t,e.dispatchEvent(r)}},r=t;for(var v=0;v<s;v++){var m=new p(i[v]),g=m.load(t,c);g!=t&&(r="")}for(var v=0;v<f;v++){var y=a[v].text;o(y,t),c()}}function f(e){var n=t[e];return n||console.warn("[l10n] #"+e+" missing for ["+r+"]"),n}function l(e,n){var r=/\{\{\s*([a-zA-Z\.]+)\s*\}\}/,i=r.exec(e);while(i){if(!i||i.length<2)return e;var s=i[1],o="";if(s in n)o=n[s];else{if(!(s in t))return console.warn("[l10n] could not find argument {{"+s+"}}"),e;o=t[s].textContent}e=e.substring(0,i.index)+o+e.substr(i.index+i[0].length),i=r.exec(e)}return e}function c(e,t,n){var r=f(e);return!r&&n&&(r={textContent:n}),r?l(r.textContent,t):"{{"+e+"}}"}function h(e){if(!e||!e.dataset)return;var t=e.dataset.l10nId,n=f(t);if(!n)return;var r;if(e.dataset.l10nArgs)try{r=JSON.parse(e.dataset.l10nArgs)}catch(i){console.warn("[l10n] could not parse arguments for #"+t+"")}for(var s in n)e[s]=l(n[s],r)}function p(e){e=e||document.querySelector("html");var t=e.querySelectorAll("*[data-l10n-id]"),n=t.length;for(var r=0;r<n;r++)h(t[r]);e.dataset.l10nId&&h(e)}function d(){t={},n="",r=""}var t={},n="",r="";document.mozL10n={get:c,get language(){return{get code(){return r},set code(e){a(e,p)},get direction(){var e=["ar","he","fa","ps","ur"];return e.indexOf(r)>=0?"rtl":"ltr"}}}}})(this);