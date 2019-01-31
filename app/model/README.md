# **model**

## **Overview**

It splitted different modules by different folders in **model** as in **handler**. **as a spec**, it include a necessary *index.lua* in each modules (folders), the remaining lua files in each modules (folders) were **module units** containing **model process functions** which were store in *index.lua* actually.

It's important to note that, **as a spec**, the business logic was processed in **model** **only** which was scheduled by **handler**.

In this demo of APIServer, using [**autoRuqire**](https://github.com/tweyseo/Mirana/blob/master/toolkit/autoRequire.lua) to require model process functions automatically, and wrapping them with [**tracer**](ttps://github.com/tweyseo/Mirana/blob/master/wrapper/plugin/tracer.lua) for invoke tracing.  

## **Useage**

## **TODO**