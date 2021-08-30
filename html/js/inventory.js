var type = "drop";
var disabled = false;
var disabledFunction = null;

window.addEventListener("message", function (event) {
    if (event.data.action == "display") {
        type = event.data.type;
        disabled = false;
        isOpen = true;
        $(".ui").fadeIn();
    } else if (event.data.action == "hide") {
        $(".ui").fadeOut();
    } else if (event.data.action == "setType") {
        type = event.data.type;
    } else if (event.data.action == "setItems") {
        inventorySetup(event.data.itemList, event.data.hotbarItems, event.data.weight, event.data.maxWeight);
    } else if (event.data.action == "setSecondInventoryItems") {
        $("#search").show();
        secondInventorySetup(event.data.itemList, event.data.weight, event.data.maxWeight, event.data.label);
    } else if (event.data.action == "showHotbar") {
        showHotbar(event.data.hotbarItems)
    } else if (event.data.action == "notify") {
        notify(event.data.item, event.data.text)
    }

    $('.item').draggable({
        helper: 'clone',
        appendTo: ".inventory",
        revertDuration: 0,
        containment: "parent",
        start: function (event, ui) {
            if (disabled) {
                $(this).stop();
                return;
            }

            itemData = $(this).data("item");
            $("#description").show();
            $("#description").html(itemData.description);

            $(this).css('background-image', 'none');
            itemInventory = $(this).data("inventory");

            if (itemInventory == "second") {
                $("#drop").addClass("disabled");
                $("#give").addClass("disabled");
                $("#use").addClass("disabled");
            }
        },
        stop: function () {
            itemData = $(this).data("item");
            $("#description").hide();

            if (itemData !== undefined && itemData.name !== undefined) {
                image = setImage(itemData);
                $(this).css('background-image', 'url(\'img/' + image + '.png\'');
                $("#drop").removeClass("disabled");
                $("#use").removeClass("disabled");
                $("#give").removeClass("disabled");
            }
        }
    });
});

function closeInventory() {
    $.post("http://vrp_inventoryhud/NUIFocusOff", JSON.stringify({
        type: type
    }));
}

function notify(item, text) {
    const itemBox = document.createElement("div")
    itemBox.classList.add("slot")

    count = setCount(item, false);
    image = setImage(item);
    itemBox.innerHTML = '<div class="item" style = "background-image: url(\'img/' + image + '.png\')"><div class="item-count">' + count + '</div><div class="item-name">' + item.label + '</div><div class="item-action">' + text + '</div><div class="item-name-bg"></div></div>'

    document.querySelector("#notifications").appendChild(itemBox)

    $(itemBox).fadeIn(250);
	setTimeout(function() {
		$.when($(itemBox).fadeOut(300)).done(function() {
			$(itemBox).remove()
		});
	}, 3000);
}

function showHotbar(hotbarItems) {
    $("#hotbar").fadeIn(200);
    for(i = 1; i < 6; i++) {
        $("#hotbar").append('<div class="slot" data-hotbar="' + i + '"></div>');
    }

    $.each(hotbarItems, function (index, item) {
        count = setCount(item, false);
        image = setImage(item);

        $("#hotbar").find("[data-hotbar=" + item.slot + "]").html('<div id="item-' + item.slot + '" class="item" style = "background-image: url(\'img/' + image + '.png\')">' +
        '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div>');
    });

    setTimeout(function() {
        $.when($("#hotbar").fadeOut(1000)).done(function() {
            $("#hotbar").html('')
        });
    }, 1000);
}

function inventorySetup(items, hotbarItems, weight, maxWeight) {
    $("#playerInventory").html("");
    $("#playerInfo").html("<h3>Main inventory</h3><p>" + round(weight) + "/" + maxWeight + " KG</p><div id='progbar'><div id='progbar-value' style='width: " + (weight * 100) / maxWeight + "%'></div></div>");
    $("#playerInfo").show();

    for(let i=1; i<6; i++) {
        // $("#playerInventory").append('<div class="slot" data-slot="' + i + '" data-type="main"><div class="item-key">' + i + '</div></div>');
        $("#playerInventory").append('<div class="slot" id="hotbar-' + i + '" data-hotbar="' + i + '"></div>');
    
        const id = "#hotbar-" + i
        $(id).droppable({
            hoverClass: 'hoverControl',
            drop: function (event, ui) {
                itemData = ui.draggable.data("item");
    
                if (itemData == undefined) {
                    return;
                }
    
                itemInventory = ui.draggable.data("inventory");
                
                if (itemInventory == undefined || itemInventory == "second") {
                    return;
                }
                
                disableInventory(300);
                $.post("http://vrp_inventoryhud/PutIntoHotbar", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val()),
                    slot: i,
                    from: itemData.slot
                }));
            }
        });
    }

    $.each(hotbarItems, function (index, item) {
        count = setCount(item, false);
        image = setImage(item);
        itemWeight = item.weight * item.count;

        $("#playerInventory").find("[data-hotbar=" + item.slot + "]").html('<div id="item-' + item.slot + '" class="item" style = "background-image: url(\'img/' + image + '.png\')">' +
        '<div class="item-count">' + count + '(' + round(itemWeight) +' kg)</div><div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div>');

        $('#item-' + item.slot).data('item', item);
        $('#item-' + item.slot).data('inventory', "hotbar");
    });

    $.each(items, function (index, item) {
        count = setCount(item, false);
        image = setImage(item);
        itemWeight = item.weight * item.count;
        index += 6;
        
        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/' + image + '.png\')">' +
        '<div class="item-count">' + count + '(' + round(itemWeight) +' kg)</div><div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
    });
}

function secondInventorySetup(items, weight, maxWeight, label) {
    if (label === undefined) {
        label = type
    }

    $("#otherInventory").html("");
    $("#otherInfo").html(maxWeight == 0 ? "<h3>" + label + "</h3>" : "<h3>" + label + "</h3><p>" + round(weight) + "/" + maxWeight + " KG</p><div id='progbar'><div id='progbar-value' style='width: " + (weight * 100) / maxWeight + "%'></div></div>");
    $("#otherInfo").show();
    $.each(items, function (index, item) {
        count = setCount(item, true);
        itemWeight = item.weight * item.count;
        image = setImage(item);

        $("#otherInventory").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/' + image + '.png\')">' +
            '<div class="item-count">' + count + '(' + round(itemWeight) +' kg)</div><div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
    });
}

function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    disabled = true;

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms);
        disabledFunction.start();
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop();
        }

        disabledFunction.start();
    }
}

function setImage(item) {
    let image = item.name;
    let split = item.name.split("|");

    if (split[0] == "wbody") {
        image = split[1];
    } else if(split[0] == "wammo") {
        image = "ammo";
    }

    return image;
}

function round(number) {
    return number.toFixed(1);
}

function setCount(item, second) {
    if (second && type === "shop") {
        return "$" + formatMoney(item.price);
    }

    count = item.count

    return count;
}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

$(document).ready(function () {
    $("#count").focus(function () {
        $(this).val("")
    }).blur(function () {
        if ($(this).val() == "") {
            $(this).val("1")
        }
    });

    $("#search").on("keyup", function (key) {
        const query = $("#search").val();
        const items = $("#otherInventory .slot .item");
        $.each(items, function (index, item) {
            const slot = $(item).parent()
            const data = $(item).data('item')
            const label = data.label.toLowerCase()
            if (label.includes(query)) {
                $(slot).show()
            } else {
                $(slot).hide();
            }
        });
    });

    $("body").on("keyup", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            closeInventory();
        }
    });

    $('#use').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");

            if (itemData == undefined) {
                return;
            }

            itemInventory = ui.draggable.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            disableInventory(300);
            $.post("http://vrp_inventoryhud/UseItem", JSON.stringify({
                item: itemData
            }));
        }
    });

    $('#playerInventory').on('dblclick', '.item', function () {
        itemData = $(this).data("item");

        if (itemData == undefined) {
            return;
        }

        itemInventory = $(this).data("inventory");

        if (itemInventory == undefined || itemInventory == "second") {
            return;
        }

        disableInventory(300);
        $.post("http://vrp_inventoryhud/UseItem", JSON.stringify({
            item: itemData
        }));
    });

    $('#give').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");

            if (itemData == undefined) {
                return;
            }

            itemInventory = ui.draggable.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            disableInventory(300);
            // $.post("http://vrp_inventoryhud/GetNearPlayers", JSON.stringify({
            //     item: itemData
            // }));
            $.post("http://vrp_inventoryhud/GiveItem", JSON.stringify({
                item: itemData,
                number: parseInt($("#count").val())
            }));
        }
    });

    $('#playerInventory').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/TakeFromChest", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "shop" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/BuyItem", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "chest" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/TakeFromChest", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "glovebox" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/TakeFromChest", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "player" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/TakeFromPlayer", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "drop" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/TakeFromDrop", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (itemInventory === "hotbar") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/TakeFromHotbar", JSON.stringify({
                    slot: itemData.slot
                }));
            }
        }
    });

    $('#otherInventory').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/PutIntoChest", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "chest" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/PutIntoChest", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "glovebox" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/PutIntoChest", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "player" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/PutIntoPlayer", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "drop" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://vrp_inventoryhud/PutIntoDrop", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });

    $("#count").on("keypress keyup blur", function (event) {
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
});