/**
var contracts={
	hello:{
		address:'0x38f8a8F895A68eEEd2577BFFb693a2bE4D518BB6',
		abi:''
	},
	diamonds:{
		address:"0xcbc48b5FFB10300BE089c8869734470898d5Da74",
		abi:''
	}
}
*/

var contracts={
	hello:{
		address:'0x38f8a8F895A68eEEd2577BFFb693a2bE4D518BB6'
	},
	diamonds:{
		//address:'0xcbc48b5FFB10300BE089c8869734470898d5Da74'
		address:'0xc15a3932c36898C42bDa3509765ABd0Df8B492d4'
	},
	worker:{	
		//address:'0x612F6f24Ee7144d565C52777d1C3b963657F1110'
		address:'0x140D2d3F35d5e998c2609FaE59A81EFfF5e90ef8'
	},
	hoe:{
		//address:'0x80dAd2c8Cc9B6cE21a541F28477E70E9FF89CFc2'
		address:'0xA9f3CeCEa730E6850dE79f35d4e931F97B452c47'
	},
	box:{
		//address:'0x0fC565d0b7507378Cc922aCA23CcAe838828A01A'
		address:'0xe06BfDC492Cd068af0D8e34fe88a65084777E19F'
	},
	game:{
		//address:'0xFAef5D34726828919B26e7d08EFA111f811845dC'
		address:'0x1f05314E481d0E8d06bEF7af7a721770C0832668'
	},
	marketWorker:{
		address:'0x145324f4eF7a0185b484367188496c020DE13F8D'
	},
	marketHoe:{
		address:'0xb29Ae2aD9ce4f344f7e0e12848468f6E7b2cbB57'
	}
}
function loadData(callback){
	//通过合约编译后的元数据，加载对应的abi设置到contracts中
	$.getJSON("service/contracts/artifacts/Hello_metadata.json", function (result){
		contracts.hello.abi=result.output.abi;
		$.getJSON("service/contracts/artifacts/Diamonds_metadata.json", function (result){
			contracts.diamonds.abi=result.output.abi;
			$.getJSON("service/contracts/artifacts/Worker_metadata.json", function (result){
				contracts.worker.abi=result.output.abi;
				$.getJSON("service/contracts/artifacts/Hoe_metadata.json", function (result){
					contracts.hoe.abi=result.output.abi;
					$.getJSON("service/contracts/artifacts/Box_metadata.json", function (result){
						contracts.box.abi=result.output.abi;
						$.getJSON("service/contracts/artifacts/Game_metadata.json", function (result){
							contracts.game.abi=result.output.abi;
							$.getJSON("service/contracts/artifacts/MarketWorker_metadata.json", function (result){
								contracts.marketWorker.abi=result.output.abi;
								$.getJSON("service/contracts/artifacts/MarketHoe_metadata.json", function (result){
									contracts.marketHoe.abi=result.output.abi;
									callback();
								});
							});
						});
					});
				});
			});
		});
	});
}

function pinWorker(obj,className){
	var cn="col-sm-3";
	if(className){
		cn=className;
	}
	var event="choseWorker('"+obj.tokenId+"')";
	var status='';
	if(obj.alow){
		status='<button class="btn btn-w-m btn-primary" type="button">可挖矿<i class="fa fa-check"></i></button>';
	}else{
		status='<button class="btn btn-w-m btn-danger" type="button">不可挖矿<i class="fa fa-close"></i></button>';
	}
	var shop='';
	if(obj.shoped){
		shop='<button class="btn btn-w-m btn-danger" type="button" onclick="cancel('+obj.tokenId+')">下架<i class="fa fa-shopping-cart"></i></button>';
	}else{
		shop='<button class="btn btn-w-m btn-primary" type="button" onclick="sale('+obj.tokenId+')">卖掉它<i class="fa fa-shopping-cart"></i></button>';
	}
	var result='<div class="'+cn+'" onclick="'+event+'">'+
		'<div class="ibox">'+
			'<div class="ibox-title">'+
				'<h5>'+obj.tokenId+'</h5>'+
			'</div>'+
			'<div class="ibox-content">'+
				'<div class="team-members">'+
					'<img alt="member" class="img-item" src="img/gongren.png" width="100%">'+
				'</div>'+
				'<span>'+status+'</span>'+
				'<span>力气：'+obj.power+'</span>'+shop+
			'</div>'+
		'</div>'+
	'</div>';
	return result;
}
function pinHoe(obj,className){
	var cn="col-sm-3";
	if(className){
		cn=className;
	}
	var event="choseHoe('"+obj.tokenId+"')";
	if(obj.alow){
		status='<button class="btn btn-w-m btn-primary" type="button">可挖矿<i class="fa fa-check"></i></button>';
	}else{
		status='<button class="btn btn-w-m btn-danger" type="button">不可挖矿<i class="fa fa-close"></i></button>';
	}
	var shop='';
	if(obj.shoped){
		shop='<button class="btn btn-w-m btn-danger" type="button" onclick="cancel('+obj.tokenId+')">下架<i class="fa fa-shopping-cart"></i></button>';
	}else{
		shop='<button class="btn btn-w-m btn-primary" type="button" onclick="sale('+obj.tokenId+')">卖掉它<i class="fa fa-shopping-cart"></i></button>';
	}
	var result='<div class="'+cn+'" onclick="'+event+'">'+
		'<div class="ibox">'+
			'<div class="ibox-title">'+
				'<h5>'+obj.tokenId+'</h5>'+
			'</div>'+
			'<div class="ibox-content">'+
				'<div class="team-members">'+
					'<img alt="member" class="img-item" src="img/chutou.png" width="100%">'+
				'</div>'+
				'<span>'+status+'</span>'+
				'<span>锋利：'+obj.power+'</span>'+shop+
			'</div>'+
		'</div>'+
	'</div>';
	return result;
}


function pinMarketWorker(obj){
	var event="choseWorker('"+obj.tokenId+"')";
	var status='';
	if(obj.alow){
		status='<button class="btn btn-w-m btn-primary" type="button">可挖矿<i class="fa fa-check"></i></button>';
	}else{
		status='<button class="btn btn-w-m btn-danger" type="button">不可挖矿<i class="fa fa-close"></i></button>';
	}
	var shop='';
	if(obj.isOwner){
		shop='<button class="btn btn-w-m btn-danger" type="button" onclick="cancel('+obj.tokenId+')">下架<i class="fa fa-shopping-cart"></i></button>';
	}else{
		shop='<button class="btn btn-w-m btn-primary" type="button" onclick="buy('+obj.tokenId+')">购买<i class="fa fa-shopping-cart"></i></button>';
	}
	var result='<div class="col-sm-3">'+
       		'<div class="ibox">'+
       			'<div class="ibox-title">'+
       				'<h5>'+obj.tokenId+'-'+obj.saller+'</h5>'+
      				'</div>'+
      				'<div class="ibox-content">'+
      					'<div class="team-members">'+
      						'<img alt="member" class="img-item" src="img/gongren.png">'+
    					'</div>'+
    					'<span>'+shop+
  						'</span>'+
					'<span>'+status+'</span>'+
     				'<span>力气：'+obj.power+'</span>'+
     				'<span>价格：'+obj.price+'</span>'+
     			'</div>'+
     		'</div>'+
   		'</div>';
	return result;
}

function pinMarketHoe(obj){
	var event="choseWorker('"+obj.tokenId+"')";
	var status='';
	if(obj.alow){
		status='<button class="btn btn-w-m btn-primary" type="button">可挖矿<i class="fa fa-check"></i></button>';
	}else{
		status='<button class="btn btn-w-m btn-danger" type="button">不可挖矿<i class="fa fa-close"></i></button>';
	}
	var shop='';
	if(obj.isOwner){
		shop='<button class="btn btn-w-m btn-danger" type="button" onclick="cancel('+obj.tokenId+')">下架<i class="fa fa-shopping-cart"></i></button>';
	}else{
		shop='<button class="btn btn-w-m btn-primary" type="button" onclick="buy('+obj.tokenId+')">购买<i class="fa fa-shopping-cart"></i></button>';
	}
	var result='<div class="col-sm-3">'+
       		'<div class="ibox">'+
       			'<div class="ibox-title">'+
       				'<h5>'+obj.tokenId+'-'+obj.saller+'</h5>'+
      				'</div>'+
      				'<div class="ibox-content">'+
      					'<div class="team-members">'+
      						'<img alt="member" class="img-item" src="img/chutou.png">'+
    					'</div>'+
    					'<span>'+shop+
  						'</span>'+
					'<span>'+status+'</span>'+
     				'<span>锋利：'+obj.power+'</span>'+
     				'<span>价格：'+obj.price+'</span>'+
     			'</div>'+
     		'</div>'+
   		'</div>';
	return result;
}