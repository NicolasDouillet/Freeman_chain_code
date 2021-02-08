% Freeman_chain_code example

I = imread('gear.jpg');
I = imbinarize(I);
[Code,a,b] = Freeman_chain_code(I,true);