# GCD: Waiting for Data using DispatchGroup and Semaphores

>### The majority of apps make networking requests, and depending on the app, you may need to call multiple apis at the same time. As opposed to chaining your calls in a synchronous manner, which is much slower, you can add them to the dispatch group and call them at the same time to increase the performance of your app.

>### Check the "MixedTwo" branch to see
***

# Part1. DispatchGroup
>### In this app, I used three APIs to crawl the data and present them on the screen. Through DispatchGroup, I can control each API separately. When the network successfully grabs the data, I will proceed to the next API. Actions.

### To use DispatchGroup is very easy, we just need         dispatchGroup.enter() and dispatchGroup.leave() 
### In the task to join the group, use .enter(), add the .leave() after use completion

```javascript
        dispatchGroup.enter()
        self.client.getNameData { (data, error) in
            self.name = data!
            print(data!)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.client.getAddressData { (data, error) in
            self.address = data!
            print(data!)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.client.getHeadData { (data, error) in
            self.head = data!
            print(data!)
            self.dispatchGroup.leave()
        }
```
### Finally, when all tasks are completed, the next step is just to use dispatchGroup.notify, set what to do next inside.
```javascript
        dispatchGroup.notify(queue: .main) {
        .....
        ........
        }
```

***

# Part2. Semaphores
>### Three steps:
>1. Whenever we would like to use one shared resource, we send a request to its semaphore;
>2. Once the semaphore gives us the green light (see what I did here?) we can assume that the resource is ours and we can use it;
>3. Once the resource is no longer necessary, we let the semaphore know by sending him a signal, allowing him to assign the resource to another thread. 
>4. Can think of these request/signal as the resource lock/unlock.


## What’s Happening Behind the Scenes
### Resource Request: wait()
#### When the semaphore receives a request, it checks if its counter is above zero: 

>- if yes, then the semaphore decrements it and gives the thread the green light;
>- otherwise it pushes the thread at the end of its queue;

### Resource Release: signal()
#### Once the semaphore receives a signal, it checks if its FIFO queue has threads in it:

>- if yes, then the semaphore pulls the first thread and give him the green light;
>- otherwise it increments its counter;

### Warning: If you do this in the main thread, the whole app will freeze 

## Let’s write some code!
```javascript
 let loadingQueue = DispatchQueue.global()
        
        loadingQueue.async {
            self.semaphore.wait()
            self.client.getNameData { (data, error) in
                if error == nil {
                    self.label1.text = data!
                    print("--------------")
                    print(data!)
                    self.semaphore.signal()
                }
            }
            
            self.semaphore.wait()
            self.client.getAddressData { (data, error) in
                self.label2.text = data!
                print(data!)
                self.semaphore.signal()
            }
            
            self.semaphore.wait()
            self.client.getHeadData { (data, error) in
                self.label3.text = data!
                print(data!)
                print("--------------")
                self.semaphore.signal()
            }
        }
```


![image](https://github.com/SpockHsueh/GCD-practice/blob/master/1_Nmcb2GTIk-PO0TNPNPD8Mw.jpeg)
