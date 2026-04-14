module top_module(
    input wire i,
    output wire o
);wire a;
   wire b;
   wire c;
   wire d;

   assign c = i + 1'b1;
   assign d = c + 1'b1;
   assign a = b + d;
   assign b = a + 1'b1;

   wire p;
   wire q;
   wire r;
   wire s;

   assign p = i + 1'b1;
   assign q = p + 1'b1;
   assign r = s ^ q;
   assign s = r + 1'b1;

   wire x;
   wire y;
   wire z;
   wire w;

   assign x = y ^ i;
   assign y = x;
   assign z = w;
   assign w = y & z;

   assign o = b | x;
endmodule