---
author: jbryan
comments: true
date: 2005-12-08 06:30:00+00:00
excerpt: I needed to have a function to keep statistics about how often a particular
  event occurred.
layout: post
slug: statistics-question
title: Statistics question
wordpress_id: 16
categories:
- Projects
---

For a recent project I was working on in Java, I needed to have a function to keep statistics about how often a particular event occurred.  In particular, I wanted to know the average rate of events over the last _t _seconds.  It is fairly straight forward to calculate the average rate of events over the life of the process (sum events and divide by uptime), however, calculating a moving average seems to be a little less intuitive.

In order to calulate the average rate for the past _t_ seconds requires keeping track of the number of events that occurred in that amount of time, which means somehow expiring events after the interval _t_.  This would mean having some list of timestamps to search and remove only the ones that are too old.  This approach has the drawback that the number of comparisons required by the CPU for a given time period _t_ would scale exponentially to the number of events in the same time period _t_ (assuming the average is computed each time the event occurs).  This is because as the number of events increases, the number of events to expire increases proportionately.

I soon reallized that for my purposes, all I really needed was an approximate, noise smoothed, indicator of the activity over the last several minutes.  After a quick review of statistics, I remembered a exponentially smoothed moving average formula:

At = At-1 + .1(Mt - At-1)  where At  is the average, and Mt is the weight given to _t_'s value.  ([a good explanation can be found here](http://www.fourmilab.ch/hackdiet/www/subsubsection1_4_1_0_8_3.html))

This particular equation is designed to be used to calculate an average at a specific interval.  However, I want to calculate an average at the time of the event.  Sure, I could set up a separate thread that monitors the number of events that took place at a specific interval, but it would be a little more straight forward and useful to me if the calculation occurred in the same thread.  This is partly because the time between events can vary greatly (10 minutes to 10 milleseconds), and if I set the interval for the monitoring thread at too low of a resolution, I don't get an accurate reading if the number of events suddenly spiked.  Similarly, if I set it too high, I use a lot of unnecessary cpu during the longer waits.

The solution I finally settled on was to use the above equation, but define Mt in terms of the interval _i_ since the last event.  I reasoned that the greater the interval _i_, the greater Mt should be.  I want to count a large number of closely occurring events should adjust the moving average less than one event that occurred 5 minutes ago.  The result is that I scaled M linearly such that an interval of 0 has a weight of 0, and an interval of 5 minutes (the time window I'm interested in) has a weight of 1.  This is the only part of this calculation I feel I may have not fairly reasoned, as it results in a formula that, for a constant rate of events, will constantly approach, but never reach, the actual rate.  Furthermore, a high rate of events will approach it's limit slower than a low rate of events.

Despite these drawbacks, this calculation did serve it's purpose fairly well.  As one watches the moving average, it approaches the actual rate with a capacitive attack and decay, and it gives a fairly reasonable indication of how the system performs.  Below is code I used.  Feel free to study it, use, and most of all critique it.  Any feedback I get on how to do this better would be appreciated.

    
    
{% codeblock lang:java linenos:true %}
    public class Statistics {
        /**
         ** Number of events that occurred.
         **/
        private long events = 0;
        
        /**
         ** The last time a connection was borrowed.
         **/
        private long lastEventTime = System.currentTimeMillis();
        /**
         ** The last computed moving load average.
         **/
        private double lastMovingLoadAvg = 0.0;
        
        /**
         ** Increments the event count and recomputes the movingLoadAverage.
         **/
        public synchronized void registerEvent( ) {
            //increment number borrowed
            this.events++;
            
            //calculate the load average
            lastMovingLoadAvg = getMovingLoadAverage();
            
            //log the last borrow time
            this.lastEventTime = System.currentTimeMillis();
        }
        
        /**
         ** Calculates the moving load average as a variation of an
         ** exponentially smoothed average.
         ** It approximates the number borrowed in the last 5 minutes using a
         ** variably weighted
         ** time since the last event occured to adjust the average.
         **/
        public double getMovingLoadAverage() {
            //current time
            long now = System.currentTimeMillis();
            
            //time since last borrow
            long timeSinceLast = now - lastEventTime;
            
            //weight closely occuring events less than distant ones (closely
            //occuring events provide more samples, or
            //are anomolies. We make our window of relevance = 5 mins (300000ms).
            double weight = timeSinceLast / 300000D;
            weight = (weight < 1) ? weight : 1;
            
            //calculate rate
            double delta = 0;
            if (timeSinceLast > 0) //avoid div by 0
                delta = (60000D / timeSinceLast) - lastMovingLoadAvg; //newrate - last avg rate
                    
            return lastMovingLoadAvg + (delta * weight);
        }
    }
{% endcodeblock %}


Soon, I'll try to post up a small applet that demonstrates this class.  If i get any great suggestions, i'll probably incorporate them as well.
