# Resilient_Observers_Comparison

Good Resilient Observes in literature and my resilent observers will be tested here.


 >The motivation to make this simulation be open-source is: **The environment is too isolated in control community**. 
 You usually find a good paper, then you need to take too much time to implement it, it is still okay if the author knows how to write a clear paper. But, usually, most of people don't know. We should borrow the idea from AI community, **"share"** is the most important motivation for progress. 
 If you agree with me, if you benefit from my sharing stuff, please join me, push our community.

 


If you use the codes, please cite

```
@inproceedings{zheng2021Resilient,
  title={Resilient Observer Design Using Pruned Support Prior},
  author={Zheng, Yu and Anubi, Olugbenga Moses},
  booktitle={},
  pages={},
  year={2021},
  organization={}
}
```

Unfortunately, we are makeing last-round of polishing. We will send it out soon and it will be attached once accepted.

You can also cite an introduction version of it (accepted):
```
@inproceedings{zheng2021Resilient,
  title={Attack-Resilient Weighted L1 Observer with Prior Pruning},
  author={Zheng, Yu and Anubi, Olugbenga Moses},
  booktitle={2021 American control conference},
  pages={},
  year={2021},
  organization={IEEE}
}
```

Any questions, please contact Yu Zheng (yz19b@fsu.edu). All rights reserved.

## Tested observers

### 1. L1 decoder
Fawzi, Hamza, Paulo Tabuada, and Suhas Diggavi. "Secure estimation and control for cyber-physical systems under adversarial attacks." IEEE Transactions on Automatic control 59.6 (2014): 1454-1467.

### 2. Switched/event triggered Luengbuger observer
Lu, An-Yang, and Guang-Hong Yang. "Secure state estimation for cyber-physical systems under sparse sensor attacks via a switched Luenberger observer." Information sciences 417 (2017): 454-464. <br>
Shoukry, Yasser, and Paulo Tabuada. "Event-triggered state observers for sparse sensor noise/attacks." IEEE Transactions on Automatic Control 61.8 (2015): 2079-2091.

### 3. Multi-Model Resilient Observer
Anubi, Olugbenga Moses, et al. "Multi-Model Resilient Observer under False Data Injection Attacks." 2020 IEEE Conference on Control Technology and Applications (CCTA). IEEE, 2020.
Anubi, Olugbenga Moses, and Charalambos Konstantinou. "Enhanced resilient state estimation using data-driven auxiliary models." IEEE Transactions on Industrial Informatics 16.1 (2019): 639-647.

### 4. Resilient Pruning Observer
Yu Zheng, et al. "Attack-Resilient Weighted L1 Observer with Prior Pruning". 2021 American Control Conference. (can be found in papers folder)

### Comparison result (estimation errors)
![estimation_error](https://user-images.githubusercontent.com/36635562/109057815-39254e80-76b0-11eb-964d-edce72b865de.png) Estimation error (LO: luenburger observer, UL1O: unconstrained L1 decoder, MMO: multi-models observer, ETLO: event triggered Luengbuger observer, RPO: Resilient Pruning Observer)


## Planned testing observers

### 5. Robust Local estiamtor + Global fusion
Nakahira, Yorie, and Yilin Mo. "Attack-Resilient H_2, H_\infty, and L1 State Estimator." IEEE Transactions on Automatic Control 63.12 (2018): 4353-4360.

### 6. Gramian-based estimator
Chong, Michelle S., Masashi Wakaiki, and Joao P. Hespanha. "Observability of linear systems under adversarial attacks." 2015 American Control Conference (ACC). IEEE, 2015.

### 7. SMT-based observer 
Shoukry, Yasser, et al. "Secure state estimation for cyber-physical systems under sensor attacks: A satisfiability modulo theory approach." IEEE Transactions on Automatic Control 62.10 (2017): 4917-4932.

## 2021/04/26 update
add real ML localization algorithm, below is the precision of the generated support prior

![Prior_precision](https://user-images.githubusercontent.com/36635562/116096584-6aea6f80-a677-11eb-9a5b-8c29c95f26ca.png)

The updated comparison result:
![application_example_result](https://user-images.githubusercontent.com/36635562/116096724-848bb700-a677-11eb-9bf8-2c4711542b0e.png)

The performance of designed FDIA:
![BDD](https://user-images.githubusercontent.com/36635562/116096879-a4bb7600-a677-11eb-94f4-6d70d3885bf3.png)

