# Haskell-Hackerrank-Helper
Simple project to help debug test-case failures in a more interactive way, that should make it easy to upload some end haskell file to Hackerrank. The core value here is being able to see the output of your code, so that you can theorize why it gave that back for debugging and reflection, relative to the output that hackerrank expects. 

For optimization issues, doing some edits outside of hackerrank is of course useful for benchmarking and figuring out what is the bulk of the time being spent.

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
