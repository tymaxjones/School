"""Build a KNN classifier from scratch."""

# Import packages
import numpy as np
import matplotlib.pyplot as plt

# Define a function takes in 2 numpy arrays and calculates the distance
# between the two
# d = \sqrt{(x_2 - x_1)^2 + (y_2-y_1)^2} for 2 variables


def distance(x1: np.ndarray, x2: np.ndarray) -> float:
    """Define function that evaluates the distance."""
    return np.sqrt(np.sum((x1 - x2) ** 2))


# Make KNN object to set parameters, fit onto training data and make
# predictions


class KNN:
    """Class of KNN with methods for fitting and predicting."""

    def __init__(self, k: int = 5) -> None:
        """Initialize with k value."""
        # Default values is 5, set to whatever is input when initializing
        self.k = k

    def fit(self, X: np.ndarray, y: np.ndarray) -> None:
        """Fit value get x predictors and y classes."""
        # Accept an X and a y
        # X should be nxn with n observations and n predictors
        # y should be nx1 with n observations and 1 set of outcomes
        self.X_train = X
        self.y_train = y
        self.n_features = X.shape[1]

    def predictOne(self, x: np.ndarray) -> int:
        """Predict one value of y."""
        # Calculate distances between x and all training data
        dist = list(map(lambda x_train: distance(x, x_train), self.X_train))

        # Get the k nearest neighbors and their y values
        k_indexes = np.argsort(dist)[: self.k]
        k_nearest_y = list(map(lambda i: self.y_train[i], k_indexes))

        # Return the most common y value of the  the k nearest neighbors
        most_common = np.argmax(np.bincount(k_nearest_y))
        return int(most_common)

    def predict(self, X: np.ndarray) -> np.ndarray:
        """Predict all y values."""
        # Check to make sure that the number of features in predict X matches
        # the fit data
        if X.shape[1] != self.n_features:
            raise ValueError("Number of features in X does not match training")

        # Map our predictOne function to each set of predictors to get all our
        # predictions
        # then return the prediction as an output
        y_pred = list(map(lambda x: self.predictOne(x), X))
        return np.array(y_pred)

    def plot(self, resolution: float = 0.5) -> None:
        """Create a visualization of KNN."""
        # Get the minimum and maximum values
        x_min = self.X_train[:, 0].min() - 1
        x_max = self.X_train[:, 0].max() + 1
        y_min = self.X_train[:, 1].min() - 1
        y_max = self.X_train[:, 1].max() + 1
        x_vals = np.arange(x_min, x_max, resolution)
        y_vals = np.arange(y_min, y_max, resolution)
        xx, yy = np.meshgrid(x_vals, y_vals)

        # Predict the class labels for each point on the mesh
        Z = self.predict(np.c_[xx.ravel(), yy.ravel()])
        Z = Z.reshape(xx.shape)

        # Make the plot
        plt.contourf(xx, yy, Z, alpha=0.4)
        axis1 = self.X_train[:, 0]
        axis2 = self.X_train[:, 1]
        plt.scatter(axis1, axis2, c=self.y_train, alpha=0.8)
        plt.xlabel("Feature 1")
        plt.ylabel("Feature 2")
        plt.title(f"KNN Decision Surface (k={self.k})")
        plt.show()
