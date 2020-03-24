Clean CelebA dataset

# Clean - CelebA - v1

This is a cleaner version of CelebA face dataset, containing 197,477 images of 9,996 celebrities.
The original [CelebA]( http://mmlab.ie.cuhk.edu.hk/projects/CelebA.html) has many mislabelled images, and we would like to clean this dataset for better model training.  
The paper of our cleaning work, "Dataset Cleaning - A Cross Validation Methodology for Large Facial Datasets using Face Recognition", can be found [here]( arxiv link)
Initially, only a small percentage (~3%) of the dataset is cleaned. The dataset can be further cleaned either by selecting to examine for cleaning a higher percentage of a dataset or by applying multiple times the procedure explained in our work.
Below you can find the data overview as well as the how to use the Clean- CelebA.
## Data overview
The Clean - CelebA is a slightly cleaned version of the original CelebA dataset. 
The table below compares our clean version with the original CelebA dataset:

| Datasets | Celebrities |  Images  |
| :--------: | :--------:| :------: |
| Original CelebA |  10,177  | 202,599 |
| Clean CelebA v1|  **9,996** |  **197,477**  |

## How to use Clean -CelebA
Clean CelebA v1 has two TXT files: " clean_CelebA_v1_img_list.txt " and " deleted_v1_ CelebA _img_list.txt ". 

" clean_CelebA_v1_img_list.txt " contains the path of all samples of the cleaned v1 of CelebA.
" deleted_v1_ CelebA _img_list.txt " contains the path of all mislabelled samples that were found through our cleaning procedure and are deleted from the CelebA dataset. 
For both files, the first column is the identity label of the image and the second column is the number of the image.
You may download the CelebA dataset and delete the file included in the deleted_v1_ CelebA _img_list.txt. Note that the cleaning procedure applies to all the CelebA dataset (train, val, test classes).
The original CelebA dataset can be downloaded on this website:
http://mmlab.ie.cuhk.edu.hk/projects/CelebA.html

## Citation information
If you use this dataset, please cite our paper as below:

The link of our paper “Dataset Cleaning - A Cross Validation Methodology for Large Facial Datasets using Face Recognition“ is:
