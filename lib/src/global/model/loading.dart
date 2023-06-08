class Loading {
  bool isLoading;
  bool hasError;

  Loading({this.isLoading = false, this.hasError = false});

  bool get loadedWithError => hasError && !isLoading;
}
