module top_module(in1, in2, in3, in4, in5, out);input in1, in2, in3, in4, in5;
output out;

wire temp1, temp2;

// AND the first two inputs
and and1(temp1, in1, in2);

// AND the third and fourth inputs
and and2(temp2, in3, in4);

// OR the two temporary outputs and the fifth input
or or1(out, temp1, temp2, in5);

endmodule