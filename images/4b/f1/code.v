module comparator_2bit(
   input [1:0]          a,
   input [1:0]          b,

   output               eq,
   output               lt,
   output               gt
);
    assign eq = (a == b);
    assign lt = (a < b);
    assign gt = (a > b);
endmodule