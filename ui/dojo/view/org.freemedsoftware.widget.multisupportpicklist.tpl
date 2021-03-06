<!--{* Smarty *}-->
<!--{*
 // $Id$
 //
 // Authors:
 //      Jeff Buchbinder <jeff@freemedsoftware.org>
 //
 // FreeMED Electronic Medical Record and Practice Management System
 // Copyright (C) 1999-2012 FreeMED Software Foundation
 //
 // This program is free software; you can redistribute it and/or modify
 // it under the terms of the GNU General Public License as published by
 // the Free Software Foundation; either version 2 of the License, or
 // (at your option) any later version.
 //
 // This program is distributed in the hope that it will be useful,
 // but WITHOUT ANY WARRANTY; without even the implied warranty of
 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 // GNU General Public License for more details.
 //
 // You should have received a copy of the GNU General Public License
 // along with this program; if not, write to the Free Software
 // Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*}-->
<!--{*

	File:	org.freemedsoftware.widget.multisupportpicklist

	Reusable multiple entry SupportModule widget.

	Parameters:

		$varname - Variable name

		$module - Module class name

		$overrideNamespace - Completely override namespace with another method path, use with $method

		$method - Method name called by $overrideNamespace, not used when $module is used.

*}-->

<script language="javascript">

	var <!--{$varname|replace:'.':''}--> = {
		count: 0,
		store: { },
		getValue: function ( ) {
			var r = [];
			for( var i in <!--{$varname|replace:'.':''}-->.store ) {
				if ( <!--{$varname|replace:'.':''}-->.store[i] ) {
					r.push( <!--{$varname|replace:'.':''}-->.store[i] );
				}
			}
			return r;
		},
		onAssign: function ( id ) {
			if ( typeof ( id ) == 'object' || typeof ( id ) == 'array' ) {
				for ( var i=0; i<id.length; i++ ) {
					try {
						if ( id[i] ) {
							<!--{$varname|replace:'.':''}-->.Assign( id[i] );
						}
					} catch (e) { }
				}
			} else {
				if ( id.match(',') ) {
					var x = id.split(',');
					for ( var i=0; i<x.length; i++ ) {
						try {
							if ( x[i] ) {
								<!--{$varname|replace:'.':''}-->.Assign( x[i] );
							}
						} catch (e) { }
					}
				} else {
					try {
						if ( id ) { <!--{$varname|replace:'.':''}-->.Assign( id ); }
					} catch (e) { }
				}
			}
		},
		Assign: function ( id ) {
			// Do reverse lookup from assignment
			dojo.io.bind({
				method: "POST",
				content: {
					param0: id
				},
				url: "<!--{$relay}-->/<!--{if $overrideNamespace}--><!--{$overrideNamespace}--><!--{else}-->org.freemedsoftware.module.<!--{$module|escape}--><!--{/if}-->.to_text",
				load: function ( type, data, evt ) {
					<!--{$varname|replace:'.':''}-->.AddValue( data, id );
				},
				mimetype: "text/json"
			});
		},
		onAddValue: function ( e ) {
			if ( e ) {
				var label = dojo.widget.byId('<!--{$varname|escape}-->_widget').getLabel( );
				<!--{$varname|replace:'.':''}-->.AddValue( label, e );
				// Clear selection box
				dojo.widget.byId('<!--{$varname|escape}-->_widget').setValue( '' );
				dojo.widget.byId('<!--{$varname|escape}-->_widget').setLabel( '' );
			}
		},
		onRemoveValue: function ( ) {
			var id = this.id.replace('<!--{$varname|escape}-->_remove_', '');
			if ( id ) {
				// Remove from index
				<!--{$varname|replace:'.':''}-->.store[ id ] = null;
				// Remove element
				document.getElementById( '<!--{$varname|escape}-->_div_' + id ).innerHTML = '';
			}
		},
		// Internal add value function
		AddValue: function ( label, value ) {
			if ( value ) {
				<!--{$varname|replace:'.':''}-->.store[ value ] = value;
				<!--{$varname|replace:'.':''}-->.count++;
				var i = document.createElement( 'div' );
				var spanA = document.createElement( 'span' );
				var spanB = document.createElement( 'a' );
				i.id = "<!--{$varname|escape}-->_div_" + value;
				spanA.innerHTML = label + ' ';
				spanA.className = "hoverHilightText";
				spanB.id = "<!--{$varname|escape}-->_remove_" + value.toString();
				spanB.innerHTML = "[X]";
				spanB.className = "clickable";
				spanB.onclick = <!--{$varname|replace:'.':''}-->.onRemoveValue;
				i.appendChild( spanA );
				i.appendChild( spanB );
				document.getElementById( '<!--{$varname|escape}-->_container' ).appendChild( i );
			}

		}
	};

	_container_.addOnLoad(function(){
		dojo.event.topic.subscribe( "<!--{$varname|escape}-->-assign", <!--{$varname|replace:'.':''}-->, "onAssign" );
		dojo.event.topic.subscribe( "<!--{$varname|escape}-->-setValue", <!--{$varname|replace:'.':''}-->, "onAddValue" );
		// Clear selection box
		dojo.widget.byId('<!--{$varname|escape}-->_widget').setValue( '' );
		dojo.widget.byId('<!--{$varname|escape}-->_widget').setLabel( '' );
	});
	_container_.addOnUnload(function(){
		dojo.event.topic.unsubscribe( "<!--{$varname|escape}-->-assign", <!--{$varname|replace:'.':''}-->, "onAssign" );
		dojo.event.topic.unsubscribe( "<!--{$varname|escape}-->-setValue", <!--{$varname|replace:'.':''}-->, "onAddValue" );
	});

</script>

<style type="text/css">

	#<!--{$varname|escape}-->_container_outer {
		padding: 1ex;
		border: 1px solid #5555ff;
	}

	#<!--{$varname|escape}-->_container * {
		size: 8pt;
		font-size: 8pt;
	}

</style>

<div id="<!--{$varname|escape}-->_container_outer">
<div id="<!--{$varname|escape}-->_container"></div>
<input dojoType="Select" value=""
	autocomplete="false"
	id="<!--{$varname|escape}-->_widget" widgetId="<!--{$varname|escape}-->_widget"
	style="width: 300px;"
	setValue="if (arguments[0]) { dojo.event.topic.publish( '<!--{$varname|escape}-->-setValue', arguments[0] ); }"
	dataUrl="<!--{$relay}-->/<!--{if $overrideNamespace}--><!--{$overrideNamespace}-->.<!--{$method}--><!--{else}-->org.freemedsoftware.module.<!--{$module|escape}-->.picklist<!--{/if}-->?param0=%{searchString}"
	mode="remote" />
</div>

