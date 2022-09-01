# Haskell-Hackerrank-Helper
Simple project to help debug test-case failures in a more interactive way, that should make it easy to upload some end haskell file to Hackerrank


Hackerrank questions require reading line by line from stdin and that you use a given package set. 

This is more exemplification than automation. Maybe I'll do that in the future but doesn't seem worth it

The idea is simply to have two functions main and main' where 

```haskell
main = main' stdin
```

This is to fit hackerrank for easy uploading of the haskell file and then:

```haskell
main' :: Handle -> IO ()
```

So that in the Main of this project, you just change the filepath to the exported test case
