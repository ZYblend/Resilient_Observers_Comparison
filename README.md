# Resilient_Observers_Comparison

Good Resilient Observes in literature and my resilent observers will be tested here.

<div class="text-blue mb-2">
  The motivation to make this simulation be open-source is: **The environment is too isolated in control community**. 
 I usually find a good paper, then I need to take too much time to implement it, it is still okay if the author know how to write a clear paper. But, usually, most of people don't know. We should borrow the idea from AI community, **share** is the most important motivation for progress. 
 If you agree with me, if you benefits from my sharing stuff, please join me, push this world.
</div>
 


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

Unfortunately, it is being under review. It will be attached accepted.

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

### 1. Robust Local estiamtor + Global fusion
Nakahira, Yorie, and Yilin Mo. "Attack-Resilient H_2, H_\infty, and L1 State Estimator." IEEE Transactions on Automatic Control 63.12 (2018): 4353-4360.

### 2. Switched/event triggered Luengbuger observer
Lu, An-Yang, and Guang-Hong Yang. "Secure state estimation for cyber-physical systems under sparse sensor attacks via a switched Luenberger observer." Information sciences 417 (2017): 454-464. <br>
Shoukry, Yasser, and Paulo Tabuada. "Event-triggered state observers for sparse sensor noise/attacks." IEEE Transactions on Automatic Control 61.8 (2015): 2079-2091.

### 3. Multi-Model Resilient Observer
Anubi, Olugbenga Moses, et al. "Multi-Model Resilient Observer under False Data Injection Attacks." 2020 IEEE Conference on Control Technology and Applications (CCTA). IEEE, 2020.
Anubi, Olugbenga Moses, and Charalambos Konstantinou. "Enhanced resilient state estimation using data-driven auxiliary models." IEEE Transactions on Industrial Informatics 16.1 (2019): 639-647.

### 4. Resilient Pruning Observer
Yu Zheng, et al. "Attack-Resilient Weighted L1 Observer with Prior Pruning". 2021 American Control Conference. (can be found in papers folder)

### Comparison result (estimation errors)
![estimation_error](https://user-images.githubusercontent.com/36635562/109057815-39254e80-76b0-11eb-964d-edce72b865de.png) Estimation error


## Planned testing observers

### 5. Gramian-based estimator
Chong, Michelle S., Masashi Wakaiki, and Joao P. Hespanha. "Observability of linear systems under adversarial attacks." 2015 American Control Conference (ACC). IEEE, 2015.

### 6. SMT-based observer 
Shoukry, Yasser, et al. "Secure state estimation for cyber-physical systems under sensor attacks: A satisfiability modulo theory approach." IEEE Transactions on Automatic Control 62.10 (2017): 4917-4932.
