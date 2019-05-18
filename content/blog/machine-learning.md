---
title: "Machine Learning explained"
slug: "machine-learning-explained"
date: 2019-05-18T15:22:12.457Z
draft: false
---

Over the past couple of weeks, I got to interact with quite a number of people who wanted to build AI (Artificial Intelligience) projects using Machine Learning (ML). There was one recurring problem I noticed in my discussions with them — they didn't actually understand what Machine Learning is. And without understanding — at least on a high level — it's nearly impossible to develop anything worth while. Except of course you intend to download AI projects off GitHub. Even then, you might have a hard time getting them to work or customizing them to suit your needs.

In this article, I'll be explaining what Machine Learning is with newbies in mind. I'll also expatiate on some of the commonly used jargon in the space so that you can more easily find your way around ML material and improve your skills.

# What is Machine Learning?
ML is an approach to building Artificial Intelligence (AI) systems which involves writing computer programs that "learn" from data. That is, they are not explicitly programmed to perform a specific task such as solving a quadratic equation or authenticating a user. Instead, they learn to solve a given problem by example.

AI is an aspect of computer science concerned with building intelligent machines or software. Intelligence is a rather vague concept (especially in today's world of tech where just about everything is "smart") so this definition is probably not sufficient.

In simple terms, intelligence in AI is the ability of computers to solve problems that are easier for humans or animals to do e.g driving a car or searching for food. There are several techniques used in AI today but our focus here is ML as you'd expect.

Say you wanted to write a program that can determine if a photo contains a dog or not. How would you go about it?

You could try to code features that may be used to identify a dog as well as what combinations of these features distinguish dogs from other animals (and objects). That's a hard enough task. But you'll also have to consider:

- __Position:__ Is the dog sitting or standing or lying down or running? What part of the photo is the dog located?
- __Size and orientation:__ How large or small is the dog in comparison to the rest of the photo? Is the photo rotated?
- __Occlusion:__ Is any part of the dog covered by another object? What part? By how much?

Let's say you succeeded in creating the perfect dog detector. What happens when you want to detect ducks. Can you repurpose the dog detector to also detect ducks. Probably not, because you'll be dealing with an almost completely new set of features and combinations.

Fortunately, ML excels in these sort of tasks because we can show an ML algorithm photos of dogs and have it figure out the necessary features and combinations, as well as consider position, size, orientation, and occlusion. More so, it can be repurposed to detect ducks, cats and indeed any other animal or object for that matter just by showing it relevant photos. We'll find out a little bit about how this can be done as we proceed.

# What are ML models?
A machine learning model is essentially a function which maps a set of inputs to a set of outputs. The inputs are features (e.g of a human being — height, weight etc) and the outputs are predictions (e.g sex — male or female).

Let's take the following mathematical function for example:

```
V = 4/3 * PI * r^3
```

This is the formula for the volume of a sphere. The input is `r` (the radius of the sphere) and the output is `V` (the sphere's volume). [Pi](https://en.wikipedia.org/wiki/Pi) is not an input since it's constant (about 3.14), as is the literal value `4/3`. The sphere volume formula was derived analytically using tools like calculus, geometry and trigonometry. Not all problems can be solved through such means. Some problems are not feasible or too complex to model in this way. It's a lot easier to show computers the problem and/or answers and have them figure out an approximate model that solves it.

### Training
Models are optimized or fine-tuned through a process known as training. Say you wanted to build your dog detector, like we considered in a previous section, by creating a machine learning model. At the point of initialization, the dog detector model is like a newborn baby. It doesn't know anything and behaves rather randomly. During training, it's shown a bunch of photos of dogs of different types, shapes and sizes, as well as photos of other objects so that it can make the right distinctions. At the end of training, you'd expect it to know how to detect dogs with a high level of accuracy.

### Datasets
Data is the heart and soul of machine learning — it's what "machines" use to "learn". A dataset is a collection of data which can be used to train, test and validate machine learning models. The more varied and rich a dataset is, the better a model we can produce. Good data directly translates to a good model. As such, it's important to know what good data for a given problem looks like and how to obtain it. Machine learning models, unlike humans need a lot of data to work well. Some models consume millions of records! Knowing where to source data as well as how to prepare it for training is an invaluable skill for any ML practitioner to hone.

### Testing
Testing is the process of evaluating a model to see how well it performs. It helps us know how well a model is doing and where it needs work, as well as benchmark it against other models. Datasets are usually divided into training and testing sets. Models are trained with one set, and tested and validated with others so that we can be sure that they're actually learning instead of overfitting. If your math teacher brings the examples they gave in class in an exam, you don't need to understand the calculations to pass. You can just cram your notes and ace the test without understanding a thing. This bad because when faced with similar problems in an external exam or competition, you'll likely perform poorly. The same goes for an overfitted model.

There are several metrics used in evaluating ML models. Some of the more popular ones include accuracy, confidence, [confusion matrices](https://en.wikipedia.org/wiki/Confusion_matrix), [mean squared error](https://en.wikipedia.org/wiki/Mean_squared_error) and [F1 score](https://en.wikipedia.org/wiki/F1_score).

# Types of ML
ML algorithms are generally classified into 3 main types. They are:

### Supervised learning
This is a type of machine learning which involves the use of labelled data. That is, we have a dataset containing input features (e.g the heights and weights of a number of people) and output labels (e.g their sex or age), and we want an ML algorithm to be able to make accurate predictions after learning from such data. Supervised learning is divided into classification and regression. Classification models output discrete values e.g "male" or "female", or "red", "blue", or "green", while regression models output continuous values such as a prediction for the price of a barrel of crude oil next year e.g $50.43.

### Unsupervised learning
Unsupervised learning involves the use of unlabelled data to build machine learning models. We basically give an algorithm data and let it figure out patterns in it. We might give an ML algorithm the weights, heights and other features of individuals in a school and it might group them into "healthy" or "sick", or "plays football", "plays basketball" or "plays volleyball". This sort of clustering provides valuable insights that can find application in a number of areas such as recommendation and segmentation.

### Reinforcement learning
Reinforcement learning involves building goal-oriented models that learn through "rewards" and "punishment". When an agent trained using reinforcement learning reaches a desired state, it is incentivized with a reward and if it reaches an undesired state, it is discouraged through punishment. This technique was used to build [AlphaGo Zero](https://deepmind.com/blog/alphago-zero-learning-scratch/), an AI agent which was able to beat the world's best [Go](https://en.wikipedia.org/wiki/Go_(game)) players.

__NB:__ I have a blog series here on Alpha Coder called [ML Chops](/tag/ml-chops-series). It's a set of tutorials on how some popular ML algorithms work and how to implement them from scratch using the Python programming language. You should check it out!

# Neural networks and deep learning
If you follow tech and startup news, you've probably heard the words "neural networks" and "deep learning" being tossed all around. What are they? And why is there so much hype around them?

A neural network is a machine learning framework made up of a collection of connected nodes called neurons arranged in layers. A neuron receives input signals from one or more neurons behind it, performs one or more computations with them and transmits an output signal to the neurons in front of it. The nodes at the ends of the network are the input and output layers while the nodes inbetween form sets of hidden layers. Neural networks are loosely modelled after biological neural networks which allow living things perform very complex physical and chemical activities. If you want to learn more about neural networks, [But what \*is\* a Neural Network?](https://www.youtube.com/watch?v=aircAruvnKk) by _3Blue1Brown_ is one of the best resources out there to give you a comprehensive introduction. 

Deep learning is the creation and training of neural networks that contain more than one hidden layer. A network with one hidden layer is a regular neural network and one with two or more hidden layers is a "deep" neural network. Deep neural networks usually perform better than regular ones because they can store more information within the network. However, using deeper neural networks doesn't necessarily translate to obtaining better results. There are other factors involved.

There's a lot of hype around neural networks and deep learning because these tools have changed the game by making feats that seemed impossible just a couple years ago possible. They are used heavily in building state-of-the-art Computer Vision and Natural Language Processing (NLP) applications today.

# ML is not a silver bullet
Analytical models, if they're possible and feasible to arrive at, are better than machine learning because they produce answers and not predictions. ML is not a silver bullet like some may have you believe. There are problems machine learning methods excel in. There are others where analytical approaches are simpler and produce better results. Before employing ML, ask yourself: can this problem be solved analytically?