# ref: Deep Learning with R by Fran�ois Chollet
# Mnist handwritten digit recognition: a first look at a neural network
library(keras)

# load data
mnist        <- dataset_mnist()
train_images <- mnist$train$x
train_labels <- mnist$train$y
test_images_ <- mnist$test$x
test_labels  <- mnist$test$y

# explore data
str(train_images)
str(train_labels)

# visualize digits
par(mfcol = c(6, 6))
par(mar   = c(0, 0, 3, 0),
    xaxs  = 'i',
    yaxs  = 'i')
for (idx in 1:36){
  im <- train_images[idx,,]
  im <- t(apply(im, 2, rev))
  image(1:28, 1:28,
    im,
    col  = gray((0:255) / 255),
    xaxt = 'n',
    main = paste(train_labels[idx])
  )
}

# reshape data
train_images <- array_reshape(train_images, c(60000, 28 * 28))
train_images <- train_images / 255
test_images  <- array_reshape(test_images_, c(10000, 28 * 28))
test_images  <- test_images / 255

# reshape labels
train_labels <- to_categorical(train_labels)
test_labels  <- to_categorical(test_labels)

# define model
network <- keras_model_sequential() %>% 
  layer_dense(units       = 512, 
              activation  = "relu", 
              input_shape = c(28 * 28)) %>% 
  layer_dense(units       = 10,  
              activation  = "softmax")

# compile model
network %>% compile(
  optimizer = "rmsprop",
  loss      = "categorical_crossentropy",
  metrics   = c("accuracy")
)

# fit model
network %>% fit(train_images, 
                train_labels, 
                epochs     = 5, 
                batch_size = 128)

# evaluate model
metrics <- network %>% evaluate(test_images, 
                                test_labels, 
                                verbose = 0)
metrics

# confusion matrix
pred      <- network %>% predict_classes(test_images)
confusion <- table(test_labels, to_categorical(pred))
confusion

# visualize predictions
par(mfcol = c(6, 6))
par(mar   = c(0, 0, 3, 0),
    xaxs  = 'i',
    yaxs  = 'i')
for (idx in 1:36){
  im <- test_images_[idx,,]
  im <- t(apply(im, 2, rev))
  image(1:28, 1:28,
        im,
        col  = gray((0:255) / 255),
        xaxt = 'n',
        main = paste(pred[idx])
  )
}

# acc, pr, rec, ...
caret::confusionMatrix(confusion)

