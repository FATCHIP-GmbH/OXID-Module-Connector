[{include file="headitem.tpl" title="GENERAL_ADMIN_TITLE"|oxmultilangassign}]

[{if $readonly }]
    [{assign var="readonly" value="readonly disabled"}]
[{else}]
    [{assign var="readonly" value=""}]
[{/if}]

[{if !$allowSharedEdit }]
    [{assign var="disableSharedEdit" value="readonly disabled"}]
[{else}]
    [{assign var="disableSharedEdit" value=""}]
[{/if}]

<div id="magicarea" ng-app="main">

    <div ng-controller="IolyCtrl">

        <script type="text/ng-template" id="my-tags-template">
            <div class="tag-template" ng-class="data.selected ? 'active' : ''">
                <div>
                    <span ng-class="data.selected ? 'active' : ''">{{data.text}}</span>
                    <a ng-if="data.selected" class="remove-button" ng-click="$removeTag()">&#10006;</a>
                </div>
            </div>
        </script>

        [{if $iolyerrorfatal ne ''}]
            <h1>[{oxmultilang ident='IOLY_MAIN_TITLE'}]</h1>
            <div class="error alert alert-danger alert-dismissable">
                [{$iolyerrorfatal}]
            </div>
        [{else}]

            <script type="text/ng-template" id="myModalContent.html">
                <div class="modal-header">
                    <h3 class="modal-title">{{headline}}</h3>
                </div>
                <div class="modal-body" ng-bind-html="content">
                    {{content}}
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" ng-click="cancel()">Cancel</button>
                    <button class="btn btn-primary" ng-click="ok()">OK</button>
                </div>
            </script>
        
            <div id="iolyheadline">
                <div class="row">
                    <div class="col-sm-12">
                        <h1>[{oxmultilang ident='IOLY_MAIN_TITLE'}]</h1>
                    </div>
                </div>
                <div class="row">
                    <!-- Split button -->
                    <div class="col-sm-10">
                        <div id="iolyinfo">
                            <div id='iolyintrotext'>[{oxmultilang ident="IOLY_MAIN_INFOTEXT"}]</div>
                            <div id="contributors">
                                <ul id='contributorslist'>
                                    <li ng-repeat="contributor in contributors | unique: 'login'">
                                        <a target='_blank' href='{{contributor.html_url}}'><img ng-src='{{contributor.avatar_url}}' style='border-radius: 100%; width: 20px;' alt='{{contributor.login}}' title='{{contributor.login}}' border='0'/></a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-2">
                        <div class="btn-group dropdown">
                            <button type="button" class="btn btn-primary dropdown-toggle btn-small buttonwidth">
                                [{oxmultilang ident='IOLY_DROPDOWN_MORE_ACTIONS'}] <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="#" ng-click="updateIoly()">[{oxmultilang ident='IOLY_IOLY_UPDATE_BUTTON'}]</a></li>
                                <li><a href="#" ng-click="updateRecipes()">[{oxmultilang ident='IOLY_RECIPE_UPDATE_BUTTON'}]</a></li>
                                <li><a href="#" ng-click="updateConnector('[{oxmultilang ident='IOLY_CONNECTOR_UPDATE_SUCCESS'}]')">[{oxmultilang ident='IOLY_CONNECTOR_UPDATE_BUTTON'}]</a></li>
                                <li><a href="#" ng-click="generateViews()">[{oxmultilang ident='IOLY_CREATE_VIEWS'}]</a></li>
                                <li><a href="#" ng-click="emptyTmp()">[{oxmultilang ident='IOLY_CLEAR_TEMP'}]</a></li>
                            </ul>
                        </div>
                    </div>
                </div>      
            </div>
            <div id="iolylogo">
                <img src="[{$oViewConf->getModuleUrl('ioly', 'ioly_logo.png')}]" border="0" alt="" title=""/>
                <div id="recipeCounter">
                    {{numRecipes}} [{oxmultilang ident="IOLY_RECIPES"}]
                </div>
            </div>
            <div class="clear"></div>
            
            <br>
            <a name="iolyerrors" id="iolyerrors"></a>
            [{if $iolyerror ne ''}]
                <div id="iolyerror" class="alert alert-danger alert-dismissable">
                    [{$iolyerror}]
                </div>
            [{/if}]

            [{if $iolymsg ne ''}]
            	<script>
                	setTimeout(function() {
        				document.getElementById('iolymsg').style.display = 'none';
    				}, 4000);
            	</script>
            	<div id="iolymsg" class="alert alert-success alert-dismissable">
                	[{$iolymsg}]
            	</div>
            [{/if}]

            <div>
                <alert ng-repeat="alert in alerts" type="{{alert.type}}" close="closeAlert($index)"><span ng-bind-html="alert.trustedMsg"></span></alert>
            </div>

            <accordion>
                <accordion-group is-open="isOpen">
                    <accordion-heading>
                        Filter
                        <i ng-class="{'glyphicon-minus':isOpen,'glyphicon-plus':!isOpen}"></i>
                    </accordion-heading>
                    <div id="filters">
                        <input type="checkbox" name="onlyInstalled" id="onlyInstalled" value="1" ng-click="refreshTable()"> [{oxmultilang ident="IOLY_ONLY_INSTALLED"}]
                        <input type="checkbox" name="onlyActive" id="onlyActive" value="1" ng-click="refreshTable()"> [{oxmultilang ident="IOLY_ONLY_ACTIVE"}]
                    </div>
                    <div class="clear"></div>

                    <div id="tags">
                        <tags-input
                                on-tag-clicked="filterTag($tag)"
                                on-tag-removed="tagRemoved($tag)"
                                ng-model="currentTags"
                                class="ti-input-sm"
                                placeholder="-"
                                template="my-tags-template">
                        </tags-input>
                    </div>
                </accordion-group>
            </accordion>

            <table id="iolyNgTable" ng-table="tableParams" show-filter="true" class="table">
                <tbody>
                <tr ng-repeat="module in $data">
                    <td data-title="'[{oxmultilang ident="IOLY_MODULE_NAME"}]'" sortable="'name'" filter="{ 'name': 'text' }" style="width: 50%;">
                        <div ng-hide="module.installed">
                        	<h2>{{module.name}}</h2>
                        	<p>{{module.desc.[{$langabbrev}]}}</p>
                        	<span class="glyphicon glyphicon-user"></span>&nbsp; {{module.vendor}}
                        	&nbsp;&nbsp;&nbsp;
                            <span class="glyphicon glyphicon-info-sign"></span>&nbsp; {{module.license}}
                            &nbsp;&nbsp;&nbsp;
                        	<span class="glyphicon glyphicon-euro"></span>&nbsp; <span ng-if="module.price == '0.00'">[{oxmultilang ident='IOLY_PRICE_FREE'}]</span><span ng-if="module.price != '0.00'">{{module.price}}</span>
                            &nbsp;&nbsp;&nbsp;
                            <span ng-show="module.active" class="glyphicon glyphicon-check"></span>&nbsp;
                            <span ng-show="module.active">active</span>&nbsp;
                        	<br><br>
                        </div>
                        <div ng-show="module.installed" style="color: #449d44;">
                        	<h2>{{module.name}} <span class="glyphicon glyphicon-ok-sign"></span></h2>
                        	<p>{{module.desc.[{$langabbrev}]}}</p>
                        	<span class="glyphicon glyphicon-user"></span>&nbsp; {{module.vendor}}
                        	&nbsp;&nbsp;&nbsp;
                            <span class="glyphicon glyphicon-info-sign"></span>&nbsp; {{module.license}}
                            &nbsp;&nbsp;&nbsp;
                        	<span class="glyphicon glyphicon-euro"></span>&nbsp; <span ng-if="module.price == '0.00'">kostenlos</span><span ng-if="module.price != '0.00'">{{module.price}}</span>
                            &nbsp;&nbsp;&nbsp;
                            <span ng-show="module.active" class="glyphicon glyphicon-check"></span>&nbsp;
                            <span ng-show="module.active">active</span>&nbsp;
                        	<br><br>
                        </div>
                    </td>
                    <td data-title="''" style="width: 35%;"></td>
                    <td data-title="'[{oxmultilang ident="IOLY_MODULE_DOWNLOAD"}]'" class="iolydownloadtd" style="width: 15%;">
                        <table>
                            <tr ng-repeat="(key, version) in module.versions">
                                <td class="iolynoline">
                                    <div ng-hide="version.installed" style="margin-bottom: 5px;"><button tooltip-placement="left" tooltip="[{oxmultilang ident='IOLY_INSTALL_MODULE_HINT'}]" type="submit" ng-click="downloadModule(module.packageString, key, '[{oxmultilang ident="IOLY_MODULE_DOWNLOAD_SUCCESS"}]')" class="loadModuleButton btn btn-large buttonwidth" ng-class="{'btn-success': version.matches, 'btn-error' : !version.matches}"><span class="glyphicon glyphicon-download"></span> [{oxmultilang ident="IOLY_BUTTON_DOWNLOAD_VERSION_1"}] {{key}} [{oxmultilang ident="IOLY_BUTTON_DOWNLOAD_VERSION_2" }]</button></div>
                                    <div ng-show="version.installed" style="margin-bottom: 5px;"><button tooltip-placement="left" tooltip="[{oxmultilang ident='IOLY_REINSTALL_MODULE_HINT'}]" type="submit" ng-click="downloadModule(module.packageString, key, '[{oxmultilang ident="IOLY_MODULE_DOWNLOAD_SUCCESS"}]')" class="loadModuleButton btn btn-large buttonwidth" ng-class="{'btn-warning': version.matches, 'btn-error' : !version.matches}"><span class="glyphicon glyphicon-play-circle"></span> [{oxmultilang ident="IOLY_BUTTON_DOWNLOAD_VERSION_1"}] {{key}} [{oxmultilang ident="IOLY_BUTTON_DOWNLOAD_VERSION_3" }]</button></div>
                                    <div ng-show="version.installed" style="margin-bottom: 5px;"><button tooltip-placement="bottom" tooltip="[{oxmultilang ident='IOLY_UNINSTALL_MODULE_HINT'}]" type="submit" ng-click="removeModule(module.packageString, key, '[{oxmultilang ident="IOLY_MODULE_UNINSTALL_SUCCESS"}]')" class="loadModuleButton  btn btn-large btn-danger buttonwidth"><span class="glyphicon glyphicon-remove-circle"></span> [{oxmultilang ident="IOLY_BUTTON_REMOVE_VERSION_1"}] {{key}} [{oxmultilang ident="IOLY_BUTTON_REMOVE_VERSION_2"}]</button><br/></div>

                                    [{if $oView->allowActivation()}]
                                        <!-- Split button -->
                                        <div class="btn-group dropdown" ng-show="version.installed">
                                            <button type="button" class="btn btn-primary dropdown-toggle btn-large buttonwidth">
                                                [{oxmultilang ident='IOLY_DROPDOWN_MORE_ACTIONS'}] <span class="caret"></span>
                                            </button>
                                            <ul class="dropdown-menu" role="menu">
                                                <li><a href="#" ng-click="activateModule(true, module.packageString, key)">[{oxmultilang ident='IOLY_ACTIVATE_MODULE'}]</a></li>
                                                <li><a href="#" ng-click="activateModule(false, module.packageString, key)">[{oxmultilang ident='IOLY_DEACTIVATE_MODULE'}]</a></li>
                                            </ul>
                                        </div>
                                    [{/if}]

                                    <div class="clear"></div>
                                    <div class="iolyinfodiv">
                                            <div ng:repeat="(subkey, versiondata) in version">
                                                <div ng-switch="subkey">
                                                    <div ng-switch-when="supported" style="float: left;  margin-left: 15px;">
                                                        <span class="glyphicon glyphicon-ok-sign"></span> [{oxmultilang ident="IOLY_OXID_VERSIONS"}] <span ng-class="{success: oxidversion == '[{ $oView->getShopMainVersion() }]'}" ng:repeat="oxidversion in versiondata">{{oxidversion}}<span ng-if="!$last">,</span> </span>
                                                    </div>
                                                    <div ng-switch-when="project" style="float: left;">
                                                    	<span class="glyphicon glyphicon-info-sign"></span> <a href="{{versiondata}}" target="_blank">[{oxmultilang ident="IOLY_PROJECT_URL"}]</a> 
                                                    </div>
                                                    <!--<div ng-switch-when="mapping">
                                                        <strong>[{oxmultilang ident="IOLY_OXID_MAPPINGS"}]: </strong>
                                                        <div ng:repeat="mappingdata in versiondata">
                                                            <div ng:repeat="(mappingkey, mappingval) in mappingdata">{{mappingkey}} => {{mappingval}}</div>
                                                        </div>
                                                    </div>-->
                                                </div>
                                            </div>
                                    </div>
                                </td>    
                            </tr>
                        </table>

                    </td>
                </tr>
                </tbody>
            </table>

        [{/if}]
    </div>
</div> <!-- /magicarea -->

<div class="clear"></div>

<hr>

<div id="iolyInfoFooter">
	[{oxmultilang ident="IOLY_VERSION_MODULE"}] <b>[{ $oView->getModuleVersion() }]</b> &mdash; [{oxmultilang ident="IOLY_VERSION_CORE"}] <b>[{ $oView->getIolyCoreVersion() }]</b>
	[{ if $oView->getIolyCookbookVersion()|count > 0  }]
		 &mdash; [{oxmultilang ident="IOLY_VERSION_RECIPES"}]
		[{ foreach key=basketindex from=$oView->getIolyCookbookVersion() name=cookbooks key=cbkey item=cbversion }]
			<b>[{ $cbkey }]</b> ([{ $cbversion }])
			[{ if !$smarty.foreach.cookbooks.last }], [{ /if }]
		[{ /foreach }]
	[{ /if }]
</div>

[{include file="bottomnaviitem.tpl"}]

[{include file="bottomitem.tpl"}]
