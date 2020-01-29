class Mesh{
  ArrayList<PVector> points;
}

//Ugh, that's gross. What if there are 2 bajillion points here and I need to find one?
// And what if I need to add a vertex to a saturated ArrayList? This is what the BVH is for.
