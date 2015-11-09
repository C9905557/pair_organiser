# Pair Organiser
** See JPB comments in the next section.**
For finding all possible combinations of pairs amongst a group

To use please edit the pair_organiser.rb file on the root (to include your set of individuals for pairing) and run like so:

```
$ ruby pair_organiser.rb 
[[["Pablo", "Dan"], ["Andrew", "Tom"], ["Rob", "Jay"], ["Norm", "Yev"]],
 [["Pablo", "Andrew"], ["Dan", "Tom"], ["Rob", "Norm"], ["Jay", "Yev"]],
 [["Pablo", "Tom"], ["Dan", "Andrew"], ["Rob", "Yev"], ["Jay", "Norm"]],
 [["Pablo", "Rob"], ["Dan", "Jay"], ["Andrew", "Norm"], ["Tom", "Yev"]],
 [["Pablo", "Jay"], ["Dan", "Rob"], ["Andrew", "Yev"], ["Tom", "Norm"]],
 [["Pablo", "Norm"], ["Dan", "Yev"], ["Andrew", "Rob"], ["Tom", "Jay"]],
 [["Pablo", "Yev"], ["Dan", "Norm"], ["Andrew", "Jay"], ["Tom", "Rob"]]]
 ```

 NOTE:  This algorithm employed uses a pseudo-random search and is not guaranteed to terminate.  I have successfully run the algorithm for up to 34 individuals, but it took six non-terminating runs before the correct solution could be generated.  If the algorithm gets stuck on a large pairing set do ctrl-C and restart a few times to see if another pseudo-random path will generate a solution.

Question on math StackExchange related to the above issue:

* http://math.stackexchange.com/questions/1477767/efficiently-partition-a-set-into-all-possible-unique-pair-combinations


Some other related bits of code:

* https://gist.github.com/tansaku/1c9a6537ee9487b23a68
* https://github.com/chn-challenger/random_pairs

## JPB comments

### Search algorithm

In `lib/pairerjp.rb`, I coded a search using the following representation: let represent the possible pairs by their arra indexes in a 7 by 7 matrix in the case of a 8 names problem (or n-1 by n-1 for n names).

R/C | 0 | 1 | 2 | 3 | 4 | 5 | 6 
---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:
0 | 0,1 | 0,2 | 0,3 | 0,4 | 0,5 | 0,6 | 0,7
1 | - | 1,2 | 1,3 | 1,4 | 1,5 | 1,6 | 1,7
2 | - | - | 2,3 | 2,4 | 2,5 | 2,6 | 2,7
3 | - | - | - | 3,4 | 3,5 | 3,6 | 3,7
4 | - | - | - | - | 4,5 | 4,6 | 4,7
5 | - | - | - | - | - | 5,6 | 5,7
6 | - | - | - | - | - | - | 6,7

For each of the 7 pairs (or n-1 pairs) in row 0, find a pair in the next higher rows that doesn't share any indexes. Repeat for each row until 4 (or n/2) distincts pairs are found. This gives 7 sets of 4 pairs (or n-1 sets of n/2 pairs).

Backtrackimg is needed because the pairs chosen in the first rows may preclude finding enough distincts pairs in the higher rows. Other pairs must then be chosen in the first rows.

Found that for 26 names, the 23rd set of 13 pairs could not be completed after a lenghty 5000 seconds calculation. I assumes that the order of the pairs in the first row had to be changed. By searching in reverse order, from pair 0,25 down to pair 0,1, the search was successfully completed after 107 seconds!

### Computing once and storing
One thing that can be done is to precompute the results. In the search, I used only the indexes of the names, that I mapped back to the names at the end. For instance, with 8 names I got:

```
[[[0, 1], [2, 3], [4, 5], [6, 7]],
 [[0, 2], [1, 3], [4, 6], [5, 7]],
 [[0, 3], [1, 2], [4, 7], [5, 6]],
 [[0, 4], [1, 5], [2, 6], [3, 7]],
 [[0, 5], [1, 4], [2, 7], [3, 6]],
 [[0, 6], [1, 7], [2, 4], [3, 5]],
 [[0, 7], [1, 6], [2, 5], [3, 4]]]
```

that I mapped to the names with a single statement:  
```ruby
set.map { |a1| a1.map { |a2| a2.map {|i| list[i]} } }
```

The `generator_tool.rb` is a quick and dirty attempt at generating the precomputed arrays for a range of even integer in a ruby hash, in the file `generated.rb`.

At first, I tried to use the original algorithm in `lib\pairer.rb`, but I noticed it was only working for 8, 16 and 32 names (see file `generated-sam.rb`).

The current `generated.rb` holds the result of my search up to 28 names.
