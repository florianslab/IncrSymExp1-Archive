var shuffleSequence = seq("instruction", "practice", rshuffle("test"), "postExp");
//var practiceItemTypes = ["practice"];
var showProgressBar = false;
var manualSendResults = true;
var counterOverride = 3;

var defaults = [
    "DynamicQuestion", {
        answers: {Yes: ["F", "Yes"], No: ["J", "No"]}
    },
    "Form", {
        hideProgressBar: true,
        continueOnReturn: true,
        saveReactionTime: true
    }
];

function get_sentence(sentence){
    return $("<p id='sentence' style='font-family: Sans serif; font-size: 1.6em; margin-bottom: 30px;'>"+sentence+".</p>");
}

function get_inference(inference){
    return $("<p>").append($("<p style='font-family: Sans serif; font-style: italic; font-size: 1.3em; margin-bottom: 20px;'>This leads me to conclude</p>"))
                   .append($("<p id='inference' style='font-style: Sans serif; font-size: 1.5em;'>"+inference+".</p>"));
}

var items = [

    //["instruction", "__SetCounter__", {}],
    
    ["instruction", "Form", {html: {include: "ProlificConsentForm.html"}}],
    
    ["instruction", "DynamicQuestion", {
        legend: "instruction",
        sentence: get_sentence("A sentence that your interlocutor said"),
        inference: get_inference("some information"),
        enabled: false,
        sequence: [
            TT("#bod", "In this experiment, you will see several sentences.", "Press Space", "mc"),
            {pause: "key\x01"},            
            {this: "sentence"},
            TT("#sentence", "The first sentence on the page corresponds to what your (fictional) interlocutor said.", "Press Space", "bc"),
            {pause: "key\x01"},
            {this: "inference"},
            TT("#inference", "Your role is to indicate, based on what your interlocutor said, whether you would conclude some information.", "Press Space", "bc"),
            {pause: "key\x01"},
            TT("#bod", "Let's practice a bit so that you get a better idea of the task.", "Press Space", "mc"),
            {pause: "key\x01"},
            function(t){ t.finishedCallback(); }
        ]
    }],
    
    ["practice", "DynamicQuestion", {
        legend: "practice1",
        sentence: get_sentence("Natalie both lives in New York and likes to run"),
        inference: get_inference("Natalie lives in the USA"),
        enabled: false,
        sequence: [
            {this: "sentence"},
            TT("#sentence", "Here your interlocutor said that Natalie lives in New York and likes to run.", "Press Space", "bc"),
            {pause: "key\x01"},
            {this: "inference"},
            TT("#inference", "You have to tell whether this leads you to conclude that Natalie lives in the USA.", "Press Space", "bc"),
            {pause: "key\x01"},
            {this: "answers", showKeys: "top"},
            TT("#Yes", "Simply press the <b>F</b> key if you conclude that Natalie lives in the USA...", "Press Space", "bc"),
            {pause: "key\x01"},
            TT("#No", "... or press the <b>J</b> key if you do not conclude that.", "Press Space", "bc"),
            {pause: "key\x01"},
            function(t){
                t.feedbackKey = true;
                t.safeBind($(document),"keydown", function(e) {
                    if (t.feedbackKey == false) return;
                    if (e.keyCode == 70)
                        TT("#Yes", "Right: your interlocutor said that Natalie <b>lives in New York</b> and likes to run, so you can conclude that she lives in the USA.", 
                           "Press Space", "bc", "feedback-right")(t);
                    else if (e.keyCode == 74)
                        TT("#No", "Wrong: your interlocutor said that Natalie <b>lives in New York</b> and likes to run, so you can conclude that she lives in the USA.",
                           "Press Space", "bc", "feedback-wrong")(t);
                    else return;
                    t.feedbackKey = false;
                });
            },
            {pause: "key\x01"},
            function(t){ t.finishedCallback(); }
        ]
    }],
    
    ["practice", "DynamicQuestion", {
        legend: "practice2",
        sentence: get_sentence("Either Ryan studied economics or he is a self-made man"),
        inference: get_inference("Ryan studied economics"),
        enabled: false,
        sequence: [
            {this: "sentence"},
            {this: "inference"},
            {this: "answers", showKeys: "top"},
            function(t){
                t.feedbackKey = true;
                t.safeBind($(document),"keydown", function(e) {
                    if (t.feedbackKey == false) return;
                    if (e.keyCode == 74)
                        TT("#No", "Right: your interlocutor said that Ryan studied economics <b>or is a self-made man</b>, so you cannot conclude for sure that he studied economics.",
                           "Press Space", "bc", "feedback-right")(t);
                    else if (e.keyCode == 70)
                        TT("#Yes", "Wrong: your interlocutor said that Ryan studied economics <b>or is a self-made man</b>, so you cannot conclude for sure that he studied economics.",
                           "Press Space", "bc", "feedback-wrong")(t);
                    else return;
                    t.feedbackKey = false;
                });
            },
            {pause: "key\x01"},
            function(t){ t.finishedCallback(); }
        ]
    }],
    
   ["postExp", "Form", {html: {include:"ProlificFeedbackPreConfirmation.html"}}],
    
   ["postExp", "__SendResults__", {}],
   
   ["postExp", "Message", {html: {include: "ProlificConfirmation.html"}, transfer: null}]
    
    ].concat(
      GetItemsFrom(data, null,
        {
          ItemGroup: ["item", "group"],
          Elements: [
                      "test",                       // Label of the item
                      "DynamicQuestion",            // Controller
                      {
                        legend: function(x){ return [x.item,x.group,x.condition,x.inference_about,x.trigger,x.sentence,x.inference].join("+"); },
                        sentence: function(x){ return get_sentence(x.sentence); },
                        inference: function(x){ return get_inference(x.inference); },
                        sequence: [
                            //{this: "legend"},       // DEBUG INFORMATION
                            {this: "sentence"},
                            {this: "inference"},
                            {this: "answers", showKeys: "top"}
                        ]                        
                      }
                    ]
        }        
      )
);
