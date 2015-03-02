function extend_image(url,element){
    //不可点击的图片特殊处理,parent节点添加extend=no
    if (element.parentElement.parentElement.getAttribute('extend') == "no") {
        return;
    }

    var setid = element.parentElement.getAttribute("photoset");
    if(setid){
        location.href = "photoset://"+setid;
        return;
    }
    var img=element.getElementsByTagName("IMG")[0];
    x=0;y=0;

    var imgId = element.parentElement.getAttribute("id");

    var showWidth = element.clientWidth;
    var showHeight = element.clientHeight;
    while( element != null ) {
        x += element.offsetLeft + element.clientLeft;
        y += element.offsetTop + element.clientLeft;
        element = element.offsetParent;
    }


    location.href="image:///"+x+"///"+y+"///"+ window.pageYOffset +"///"+url+"///"+showWidth+"///"+showHeight + "///" + imgId;

}

function getLinkRect()
{
    var results = new Array();
    var links = document.getElementsByTagName('a');
    for (i = 0; i < links.length; i++)
    {
        var rect = links[i].getBoundingClientRect();
        results.push(rect);
    }
    var divs = document.getElementsByTagName('div');
    for (i = 0; i < divs.length; i++)
    {
        if (divs[i].className == 'photo_big' || divs[i].className.lastIndexOf('apper', 0) === 0/*apper开头*/)
        {
            var rect = divs[i].getBoundingClientRect();
            results.push(rect);
        }
    }
    var jsonString = JSON.stringify(results);
    return jsonString;
}

function getImageRect()
{
    var results = new Array();
    for (i = 0; ; i++)
    {
        var imageID = "image_" + i;
        var image = document.getElementById(imageID);
        if(image)
        {
            var rect = image.getBoundingClientRect(); 
            var theRect = new Object();
            theRect.bottom = rect.bottom;
            theRect.height = rect.height;
            theRect.left = rect.left;
            theRect.right = rect.right;
            theRect.top = rect.top + window.pageYOffset;
            theRect.width = rect.width;
            results[i] = theRect;

        } else {
            break;
        }
    }
    var jsonString = JSON.stringify(results);
    return jsonString;
}

function download_image(element){
    element.onclick = function() { return false; };
    element.innerHTML="<span> 下载中...</span>";
    location.href="downimage://" + element.parentElement.getAttribute("id").split('_')[1];
}

function image_loaded(element){
    element.className = 'loaded';
}

function play_video(url,boardcast,element){
    location.href="video:///"+boardcast+"///" + url;
}

function sub_topic(element){
    var className = element.className;
    if(className=='topic_plus no_tc'){
        element.className = 'topic_check no_tc';
        location.href = "topic://sub//"+element.getAttribute("id").split('_')[2];
    }else{
        element.className = 'topic_plus no_tc';
        location.href = "topic://unsub//"+element.getAttribute("id").split('_')[2];
    }
    return false;
}

function onLoad(){
    //处理推荐栏目
    var topics_section = document.getElementById('topics_section');
    if(topics_section){
        var topicLinks = topics_section.getElementsByTagName('li');
        
        for(var i = 0; i < topicLinks.length; i++){
            topicLinks[i].addEventListener('touchstart', function(event){
                                            var touch = event.touches[0];
                                            //如果点击区域在最右边的100，就不走hover
                                            if(touch.pageX<320-100){
                                                this.id = "hover";
                                            }
                                        }, false);
            topicLinks[i].addEventListener('touchend', function(){
                                        for(var j = 0; j < topicLinks.length; j++){
                                            topicLinks[j].id = ""
                                        }}, false);
        }
    }
    //相关新闻
    var relative_section = document.getElementById('relative_section');
    if(relative_section){
        var myLinks = relative_section.getElementsByTagName('li');
        
        for(var i = 0; i < myLinks.length; i++){
            myLinks[i].addEventListener('touchstart', function(event){
                                            this.id = "hover";
                                        }, false);
            myLinks[i].addEventListener('touchend', function(){
                                            for(var j = 0; j < myLinks.length; j++){
                                                myLinks[j].id = ""
                                        }}, false);
            myLinks[i].addEventListener('click', function(event){
                                            this.firstChild.className="no_tc read";
                                        }, false);
        }
    }
    //内嵌应用
    var apps = document.getElementsByClassName('apper');
    if(apps && apps.length){
        for(var i = 0; i < apps.length; i++){
            apps[i].addEventListener('touchstart', function(event){
                                            this.id = "hover";
                                        }, false);
            apps[i].addEventListener('touchend', function(){
                                            this.id = "";
                                        }, false);
            apps[i].addEventListener('click', function(event){
                                     location.href = "apper:///" + this.getAttribute("url");
                                        }, false);
        }
    }
    setTimeout(function(){location.href = "show://" + document.body.scrollHeight;},100);
}
function reshow(){
    location.href = "reshow://" + document.body.scrollHeight;
}

window.addEventListener('load', onLoad, false);

/*
热门跟贴相关
*/
function addCommentSectionHeader()
{
    //暂时去掉查看全部
//    var headerHTML = "<div id='comment_section' class='section'><div class='section_header'>热门跟贴<a href='comment://'>查看全部</a></div><ul><a id='comment_list' href='comment://' class='no_tc'></a></ul>";
    var headerHTML = "<div id='comment_section' class='section'><div class='section_header'>热门跟贴</div><ul><a id='comment_list' href='comment://' class='no_tc'></a></ul>";

    document.getElementById('comments_container').innerHTML = headerHTML;
}

function buildFloors(floors)
{
    var first = true;
    for (var i = 0,len = floors.length; i < len; i++) {
        var f = floors[i];
        var icon = f["icon"];
        var name = f["name"];
        var vote = f["vote"];
        var body = f["body"];
        buildSingleFloor(icon,name,vote,body,first);
        first = false;
    };
}

function buildSingleFloor(usericon,username,vote,body,first)
{
    var floor = document.createElement('li');
    if (first == true) {
        floor.className = 'first';
    };

    //头像、用户名
    var titleDiv = document.createElement('div');
    titleDiv.className = 'floor_title';
    var iconImg = '<i></i>';
    if (usericon.length > 1) {
        iconImg = "<i><img src='" + usericon + "' onerror='clearImage(this)'></img></i>";
    };
    titleDiv.innerHTML = iconImg + "<b>" + username + "</b>";

    //顶数
    var subSpan = document.createElement('span');
    subSpan.innerHTML = vote;
    titleDiv.appendChild(subSpan);

    //正文
    var bodyDiv = document.createElement('div');
    bodyDiv.className = 'floor_body';
    bodyDiv.innerHTML = body;

    //拼凑好平房并加到列表上
    floor.appendChild(titleDiv);
    floor.appendChild(bodyDiv);
    var list = document.getElementById('comment_list');
    list.appendChild(floor);
}

function clearImage(element)
{
    element.style.display = "none";
}

/*
投票相关
*/
function checkVoteOption(element)
{
    var voteTitle = document.getElementById("vote_title");
    var isMultiple = voteTitle.getAttribute("mutliple");
    if (isMultiple == "true") {
        //多选
        var selected = element.getAttribute("selected");
        if (selected == "true") {
            element.removeAttribute("selected");
            checkVoteSubmitButtonStatus();
        }else{
            element.setAttribute("selected",true);
            setSubmitButtonEnable(true);
        }
    }else{
        //单选时直接提交
        submitVote(element.getAttribute("id"));
    }
}

function setSubmitButtonEnable(enable){
    var submit = document.getElementById("vote_submit");
    var submitButton = submit.firstChild;
    if (enable == true) {
        submitButton.removeAttribute("disable");
    }else{
        submitButton.setAttribute("disable","true");
    }
}

function checkVoteSubmitButtonStatus(){
    var itemChecked = false;
    var buttons = document.getElementById("vote_body").getElementsByTagName("a");
    for (var i = 0; i < buttons.length; i++) {
        var button = buttons[i];
        var selected = button.getAttribute("selected");
        if (selected == "true") {
            itemChecked = true;
            break;
        }
    }
    setSubmitButtonEnable(itemChecked);
}

function submitButtonClicked(element){
    var submitDisable = element.getAttribute("disable");
    if (submitDisable == "true") {
        return;
    }
    var selectedIds = "";
    var buttons = document.getElementById("vote_body").getElementsByTagName("a");
    for (var i = 0; i < buttons.length; i++) {
        var button = buttons[i];
        var selected = button.getAttribute("selected");
        var itemid = button.getAttribute("id");
        if (itemid != null && selected == "true") {
            selectedIds = selectedIds + itemid + ",";
        }
    }
    submitVote(selectedIds);
}

function submitVote(itemid){
    location.href = "vote://" + itemid;
}

function buildVoteResults()
{
    var buttons = document.getElementById("vote_body").getElementsByTagName("a");
    var colors = ["#6b96d1","#64a342","#b71925","#dd6b17","#af2f84","#9cb753","#2e849f","#7657ae"];
    for (var i = 0; i < buttons.length; i++) {
        var button = buttons[i];
        //如果是提交按钮，就隐藏
        var isSubmit = button.getAttribute("submit");
        if (isSubmit == "true") {
            var submitDiv = button.parentElement;
            submitDiv.parentElement.removeChild(submitDiv);
            reshow();
            continue;
        }
        //更改文字样式
        button.onclick = "";
        button.className = "vote_resultTitle no_tc";
        //添加进度条
        var percentage = button.getAttribute("percentage");
        var item = button.parentElement;
        var statisticBar = document.createElement("b");
        statisticBar.className = "vote_statisticBar";
        statisticBar.style.backgroundColor = colors[i % colors.length];
        statisticBar.onload = statisticBarLoaded(statisticBar,260*percentage);
        item.appendChild(statisticBar);            
        //百分比数字
        var statisticLabel = document.createElement("span");
        statisticLabel.innerText = (percentage * 100).toFixed(0) + "%";
        item.appendChild(statisticLabel);
    }
}

function updateVoteStatus(status)
{
    document.getElementById("vote_status").innerText = status;

    //目前调用此方法的时机一定是投票成功时，所以在此将参与人数+1
    var numberElement = document.getElementById("vote_number");
    var number = numberElement.innerText.match(new RegExp("\\d+"));
    number++;
    numberElement.innerText = number + "人";
}

function voteOptionButtonLoaded()
{
    var buttons = document.getElementById("vote_body").getElementsByTagName("a");
    for (var i = 0; i < buttons.length; i++) {
        var button = buttons[i];
        button.addEventListener('touchstart', function(){
            this.setAttribute("hover",true);
        }, false);
        button.addEventListener('touchend', function(){
            this.removeAttribute("hover");
        }, false);
    }
}

function statisticBarLoaded(element,width){
        setTimeout(function(){
            element.style.width = width;
        },0);
}