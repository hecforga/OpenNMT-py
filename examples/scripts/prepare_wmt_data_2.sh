#!/bin/bash

##################################################################################
# Starting from here, original files are supposed to be in $DATA_PATH
# a data folder will be created in scripts/wmt
##################################################################################

export PATH=$SP_PATH:$PATH

# Data preparation using SentencePiece
# First we concat all the datasets to train the SP model
if true; then
 echo "$0: Training sentencepiece model"
 rm -f $DATA_PATH/train.txt
 for ((i=1; i<= ${#corpus[@]}; i++))
 do
  for f in $DATA_PATH/${corpus[$i]}.$sl $DATA_PATH/${corpus[$i]}.$tl
   do
    cat $f >> $DATA_PATH/train.txt
   done
 done
 spm_train --input=$DATA_PATH/train.txt --model_prefix=$DATA_PATH/wmt$sl$tl \
           --vocab_size=$vocab_size --character_coverage=1
 rm $DATA_PATH/train.txt
fi

# Second we use the trained model to tokenize all the files
# This is not necessary, as it can be done on the fly in OpenNMT-py 2.0
# if false; then
#  echo "$0: Tokenizing with sentencepiece model"
#  rm -f $DATA_PATH/train.txt
#  for ((i=1; i<= ${#corpus[@]}; i++))
#  do
#   for f in $DATA_PATH/${corpus[$i]}.$sl $DATA_PATH/${corpus[$i]}.$tl
#    do
#     file=$(basename $f)
#     spm_encode --model=$DATA_PATH/wmt$sl$tl.model < $f > $DATA_PATH/$file.sp
#    done
#  done
# fi

# We concat the training sets into two (src/tgt) tokenized files
# if false; then
#  cat $DATA_PATH/*.$sl.sp > $DATA_PATH/train.$sl
#  cat $DATA_PATH/*.$tl.sp > $DATA_PATH/train.$tl
# fi

#  We use the same tokenization method for a valid set (and test set)
# if true; then
#  perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$validset-src.$sl.sgm \
#     | spm_encode --model=$DATA_PATH/wmt$sl$tl.model > $DATA_PATH/valid.$sl.sp
#  perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$validset-ref.$tl.sgm \
#     | spm_encode --model=$DATA_PATH/wmt$sl$tl.model > $DATA_PATH/valid.$tl.sp
#  perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$testset-src.$sl.sgm \
#     | spm_encode --model=$DATA_PATH/wmt$sl$tl.model > $DATA_PATH/test.$sl.sp
#  perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$testset-ref.$tl.sgm \
#     | spm_encode --model=$DATA_PATH/wmt$sl$tl.model > $DATA_PATH/test.$tl.sp
# fi

# Parse the valid and test sets
if true; then
 perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$validset-src.$sl.sgm \
    > $DATA_PATH/valid.$sl
 perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$validset-ref.$tl.sgm \
    > $DATA_PATH/valid.$tl
 perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$testset-src.$sl.sgm \
    > $DATA_PATH/test.$sl
 perl $TEST_PATH/input-from-sgm.perl < $TEST_PATH/$testset-ref.$tl.sgm \
    > $DATA_PATH/test.$tl
fi
