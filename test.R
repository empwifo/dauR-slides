# Create a linear regression model
model <- lm(mpg ~ log(hp) + cyl,
            data = mtcars)
# Print a model summary for "model"
summary(model)