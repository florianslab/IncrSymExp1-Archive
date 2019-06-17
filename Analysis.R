# Calling packages
library(reshape2)
library(plyr)
library(ggplot2)
library(lme4)
require(scales)

results <- read.csv("results", comment.char="#", header=F)
datasource <- read.csv("Datasource.csv", comment.char="#", header=T)
datasource <- datasource[,c("item", "group", "condition", "type", "internal_order", "expected_response", "inference_about")]

# NOTE (FS, 6/7/2018): added 'inference_about' from datasource. The replacement below didn't work out quite right for some of the fillers because of empty trigger and trigger_form fields

names(results) <- c("ReceptionTime", "IP", "Controller", "It", "Elements", "Type", "Dummy", "Question", "Answer", "Correct", "Time")

meta <- subset(results, Controller!="DynamicQuestion")
results <- subset(results, Controller=="DynamicQuestion")

# Since we used '+' as a separating char, we replace the one in 'p+'
results$Question <- sub("[+][+]", "p+", results$Question)
results <- cbind(results, colsplit(results$Question, "[+]", c("item","group","condition","inference_about2", "trigger", "sentence", "inference")))
# NOTE (FS, 6/7/2018): renamed 'inference_about' to 'inference_about2' due to problem above; kept it to double check nothing got screwed up

# Adding "type" and "expected_response"
results <- merge(results, datasource)

length(unique(results$IP))
#[1] 50

ddply(results, .(group), summarize, N=length(Answer)/80)
# group  N
    # 1 11
    # 2 13
    # 3 15
    # 4 11

# RESULTS (UNFILTERED): effect of internal_order, but also in filler_presuppositional about pp
ddply(results, .(type, inference_about, inference_about2, internal_order), summarize, InferenceRate=mean(Answer=="Yes"), SD=sd(Answer=="Yes"), N=length(Answer))

                                             type inference_about inference_about2 internal_order
1                    control_non_presuppositional               p                p           <NA>
2                        control_presuppositional               p                p           <NA>
3         filler_conjunctive_non_presuppositional               c               cp           <NA>
4         filler_conjunctive_non_presuppositional               p               pp           <NA>
5         filler_conjunctive_non_presuppositional              p+               pp           <NA>
6             filler_conjunctive_presuppositional               c                c           <NA>
7             filler_conjunctive_presuppositional               p                p           <NA>
8             filler_conjunctive_presuppositional              p+               pp           <NA>
9  filler_non_presuppositional_complex_antecedent               c                c  in_fact_first
10 filler_non_presuppositional_complex_antecedent               c                c in_fact_second
11 filler_non_presuppositional_complex_antecedent               p                p  in_fact_first
12 filler_non_presuppositional_complex_antecedent               p                p in_fact_second
13 filler_non_presuppositional_complex_antecedent              p+               pp  in_fact_first
14 filler_non_presuppositional_complex_antecedent              p+               pp in_fact_second
15     filler_presuppositional_complex_antecedent               c                c        p_first
16     filler_presuppositional_complex_antecedent               c                c       p_second
17     filler_presuppositional_complex_antecedent              p+               pp        p_first
18     filler_presuppositional_complex_antecedent              p+               pp       p_second
19      filler_presuppositional_simple_antecedent               c                c           <NA>
20                                           test               p                p        p_first
21                                           test               p                p       p_second
   InferenceRate        SD   N
1      0.1375000 0.3448057 400
2      0.7450000 0.4364071 400
3      0.8800000 0.3282607  50
4      1.0000000 0.0000000  74
5      1.0000000 0.0000000  76
6      0.9000000 0.3030458  50
7      0.9210526 0.2714484  76
8      0.9864865 0.1162476  74
9      0.3500000 0.4793725 100
10     0.3900000 0.4902071 100
11     0.2049180 0.4053062 122
12     0.1384615 0.3467199 130
13     0.2078652 0.4069244 178
14     0.3647059 0.4827696 170
15     0.3300000 0.4713927 200
16     0.2750000 0.4476348 200
17     0.5550000 0.4982129 200
18     0.2850000 0.4525472 200
19     0.2450000 0.4306258 400
20     0.7750000 0.4181053 400
21     0.4900000 0.5005260 400

# OLD with screwed up inference_about for some of the fillers
                                             type inference_about internal_order InferenceRate        SD   N

19                                           test               p        p_first     0.7750000 0.4181053 400
20                                           test               p       p_second     0.4900000 0.5005260 400
1                    control_non_presuppositional               p           <NA>     0.1375000 0.3448057 400
2                        control_presuppositional               p           <NA>     0.7450000 0.4364071 400


16     filler_presuppositional_complex_antecedent              pp        p_first     0.5550000 0.4982129 200
17     filler_presuppositional_complex_antecedent              pp       p_second     0.2850000 0.4525472 200
14     filler_presuppositional_complex_antecedent               c        p_first     0.3300000 0.4713927 200
15     filler_presuppositional_complex_antecedent               c       p_second     0.2750000 0.4476348 200

18      filler_presuppositional_simple_antecedent               c           <NA>     0.2450000 0.4306258 400


10 filler_non_presuppositional_complex_antecedent               p  in_fact_first     0.2049180 0.4053062 122
11 filler_non_presuppositional_complex_antecedent               p in_fact_second     0.1384615 0.3467199 130

12 filler_non_presuppositional_complex_antecedent              pp  in_fact_first     0.2078652 0.4069244 178
13 filler_non_presuppositional_complex_antecedent              pp in_fact_second     0.3647059 0.4827696 170

8  filler_non_presuppositional_complex_antecedent               c  in_fact_first     0.3500000 0.4793725 100
9  filler_non_presuppositional_complex_antecedent               c in_fact_second     0.3900000 0.4902071 100


3         filler_conjunctive_non_presuppositional              cp           <NA>     0.8800000 0.3282607  50
4         filler_conjunctive_non_presuppositional              pp           <NA>     1.0000000 0.0000000 150
5             filler_conjunctive_presuppositional               c           <NA>     0.9000000 0.3030458  50
6             filler_conjunctive_presuppositional               p           <NA>     0.9210526 0.2714484  76
7             filler_conjunctive_presuppositional              pp           <NA>     0.9864865 0.1162476  74


# Taking a closer look at fillers: effect very small with 'aware,' but present with every other trigger
ddply(subset(results, type=="filler_presuppositional_complex_antecedent"&inference_about=="pp"),
      .(trigger, internal_order), summarize, InferenceRate=mean(Answer=="Yes"), SD=sd(Answer=="Yes"), N=length(Answer))
   
   trigger internal_order InferenceRate        SD  N

1 continue        p_first          0.66 0.4785181 50
2 continue       p_second          0.34 0.4785181 50

3 is aware        p_first          0.46 0.5034574 50
4 is aware       p_second          0.32 0.4712121 50

5 is happy        p_first          0.58 0.4985694 50
6 is happy       p_second          0.20 0.4040610 50

7     stop        p_first          0.52 0.5046720 50
8     stop       p_second          0.28 0.4535574 50


# HERE LOOKING AT PRESUPPOSITIONAL FILLERS, BUT NOT A VERY GOOD METHOD SINCE DISTRIBUTION IS UNBALANCED (SPECIFIC ITEM EFFECTS)
# Problem: one "plan" item (70) was coded as "in fact first" for g3 and g4 (about p) but sentence was actually "in fact second"
ddply(subset(results, type=="filler_non_presuppositional_complex_antecedent"&inference_about=="p"),
      .(trigger, internal_order), summarize, InferenceRate=mean(Answer=="Yes"), SD=sd(Answer=="Yes"), N=length(Answer))
  
  trigger internal_order InferenceRate        SD  N

1   doubt  in_fact_first     0.0800000 0.2740475 50
2   doubt in_fact_second     0.2000000 0.4140393 15 # What is driving the contrast here? Probably the specific item

3    hope  in_fact_first     0.2800000 0.4535574 50
4    hope in_fact_second     0.2000000 0.4140393 15

5    plan  in_fact_first     0.3636364 0.5045250 11 # Actually "second" (mistake) but suggests item-specific effect
6    plan in_fact_second     0.0800000 0.2740475 50

7     try  in_fact_first     0.2727273 0.4670994 11
8     try in_fact_second     0.1600000 0.3703280 50


# Differences between triggers: highest contrast for 'happy,' smallest for 'stop'
  # Embedded conjunctive reading more plausible for 'happy'? "If John is happy that [Sam is in France and she is in Europe]"
ddply(subset(results, condition%in%c("nP","P","TrF","TrL")), .(trigger, condition), summarize, 
      InferenceRate=mean(Answer=="Yes"), SD=sd(Answer=="Yes"), N=length(Answer))

    trigger condition InferenceRate        SD   N

1     aware        nP          0.13 0.3379977 100
2     aware         P          0.65 0.4793725 100
3     aware       TrF          0.76 0.4292347 100
4     aware       TrL          0.50 0.5025189 100

5  continue        nP          0.16 0.3684529 100
6  continue         P          0.86 0.3487351 100
7  continue       TrF          0.85 0.3588703 100
8  continue       TrL          0.56 0.4988877 100

9     happy        nP          0.09 0.2876235 100
10    happy         P          0.77 0.4229526 100
11    happy       TrF          0.78 0.4163332 100
12    happy       TrL          0.38 0.4878317 100

13     stop        nP          0.17 0.3775252 100
14     stop         P          0.70 0.4605662 100
15     stop       TrF          0.71 0.4560480 100
16     stop       TrL          0.52 0.5021167 100


# Differences between groups: seemingly no difference (i.e. good control for item variation)
ddply(subset(results, condition%in%c("nP","P","TrF","TrL")), .(condition, group), summarize, InferenceRate=mean(Answer=="Yes"), N=length(Answer))

   Condition Group InferenceRate   N
1         nP     1     0.1477273  88
2         nP     2     0.1250000 104
3         nP     3     0.1416667 120
4         nP     4     0.1363636  88

5          P     1     0.7954545  88
6          P     2     0.7980769 104
7          P     3     0.7083333 120
8          P     4     0.6818182  88

9        TrF     1     0.8522727  88
10       TrF     2     0.7692308 104
11       TrF     3     0.7333333 120
12       TrF     4     0.7613636  88

13       TrL     1     0.5113636  88
14       TrL     2     0.4711538 104
15       TrL     3     0.4500000 120
16       TrL     4     0.5454545  88

# Item-specific effects? Overall, mostly over 0.0
plot(ddply(subset(results, condition%in%c("TrF","TrL")), .(item), 
      function(x){ return(mean(x$Answer[x$condition=="TrF"]=="Yes")-mean(x$Answer[x$condition=="TrL"]=="Yes")) }))



# General results
ggplot(subset(results, item < 33), aes(type, as.numeric(Answer=="Yes"), fill=addNA(internal_order)))+
  stat_summary(fun.y=mean, geom='bar', pos='dodge')+
  stat_summary(fun.data = mean_se, geom = "errorbar", pos=position_dodge(width=0.9), aes(width=0.5))+
  ylab("Inference Rate")+
  theme(legend.position="top", text = element_text(size=20))+
  scale_fill_manual(name="Embedding conjunct", labels=c("First", "Second"),
                    breaks = c("p_first","p_second"),
                    values=c("#E69F00", "#56B4E9"), na.value="#999999")+
  scale_x_discrete(name=NULL, labels=c("Simple (no Ps)", "Simple (Ps)", "Conjunction (Ps)")) +
  scale_y_continuous(labels=percent, limits=c(0,1))

# per trigger
ggplot(subset(results, item < 33), aes(type, as.numeric(Answer=="Yes"), fill=addNA(internal_order)))+
  stat_summary(fun.y=mean, geom='bar', pos='dodge')+
  ylab("Inference Rate")+
  theme(legend.position="top", text = element_text(size=20))+
  scale_fill_manual(name="Embedding conjunct", labels=c("First", "Second"),
                    values=c("#E69F00", "#56B4E9"), na.value="#999999")+
  scale_x_discrete(name=NULL, labels=c("Simple (no Ps)", "Simple (Ps)", "Conjunction (Ps)"))+
  facet_wrap(~trigger)


# Looking at results per items where p+ = adjective + noun vs others
items.adjN <- c(10,18,20,21,25,28,29,30)
ggplot(subset(results, item%in%items.adjN), aes(type, as.numeric(Answer=="Yes"), fill=addNA(internal_order)))+
  stat_summary(fun.y=mean, geom='bar', pos='dodge')+
  ylab("Inference Rate")+
  theme(legend.position="top", text = element_text(size=20))+
  scale_fill_manual(name="Embedding conjunct", labels=c("First", "Second"),
                    values=c("#E69F00", "#56B4E9"), na.value="#999999")+
  scale_x_discrete(name=NULL, labels=c("Simple (no Ps)", "Simple (Ps)", "Conjunction (Ps)"))
ggplot(subset(results, item<33 & !(item%in%items.adjN)), aes(type, as.numeric(Answer=="Yes"), fill=addNA(internal_order)))+
  stat_summary(fun.y=mean, geom='bar', pos='dodge')+
  ylab("Inference Rate")+
  theme(legend.position="top", text = element_text(size=20))+
  scale_fill_manual(name="Embedding conjunct", labels=c("First", "Second"),
                    values=c("#E69F00", "#56B4E9"), na.value="#999999")+
  scale_x_discrete(name=NULL, labels=c("Simple (no Ps)", "Simple (Ps)", "Conjunction (Ps)"))
# facet wrap
ggplot(subset(results, item%in%items.adjN), aes(type, as.numeric(Answer=="Yes"), fill=addNA(internal_order)))+
  stat_summary(fun.y=mean, geom='bar', pos='dodge')+
  ylab("Inference Rate")+
  theme(legend.position="top", text = element_text(size=20))+
  scale_fill_manual(name="Embedding conjunct", labels=c("First", "Second"),
                    values=c("#E69F00", "#56B4E9"), na.value="#999999")+
  scale_x_discrete(name=NULL, labels=c("Simple (no Ps)", "Simple (Ps)", "Conjunction (Ps)")) +
  facet_wrap(~item)
ggplot(subset(results, item<33 & !(item%in%items.adjN)), aes(type, as.numeric(Answer=="Yes"), fill=addNA(internal_order)))+
  stat_summary(fun.y=mean, geom='bar', pos='dodge')+
  ylab("Inference Rate")+
  theme(legend.position="top", text = element_text(size=20))+
  scale_fill_manual(name="Embedding conjunct", labels=c("First", "Second"),
                    values=c("#E69F00", "#56B4E9"), na.value="#999999")+
  scale_x_discrete(name=NULL, labels=c("Simple (no Ps)", "Simple (Ps)", "Conjunction (Ps)")) +
  facet_wrap(~item)



results$filler <- results$type
levels(results$filler) <- c("Simple-No-Ps", "Simple-Ps", "(e) Conj-No-Ps", "(d) Conj-Ps", "(b) Complex-No-Ps", "(a) Complex-Ps", "(c) Simple-Ps", "test")

results$filler <- as.factor(as.character(results$filler))

results$inference <- results$inference_about

results$order <- results$internal_order

levels(results$order) <- c("EmbeddingConj-Second", "EmbeddingConj-First", "EmbeddingConj-First", "EmbeddingConj-Second")

results$order <- relevel(results$order, "EmbeddingConj-First")

# item 79 coded as presuppositional with 'continue', but sentence just reads 'Lilijan works for Google; she lives in California'
subset(results, item=="79")$type <- "filler_conjunctive_non_presuppositional"
results$type[results$item=="79"] <- "filler_conjunctive_non_presuppositional"

ggplot(subset(results, item > 32 & type!="test"), aes(inference, as.numeric(Answer=="Yes"), fill=order))+
  stat_summary(fun.y=mean, geom='bar', pos='dodge')+
  ylab("Inference Rate")+
  theme(legend.position=c(0.85, 0.3), text = element_text(size=20))+
  scale_fill_manual(name="Embedding conjunct", labels=c("First", "Second"),
                    values=c("#E69F00", "#56B4E9"), na.value="#999999")+
#  scale_x_discrete(name=NULL, labels=c("Simple (no Ps)", "Simple (Ps)", "Conjunction (Ps)"))+
  facet_wrap(~filler)
