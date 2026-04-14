module truth_table (
    input w, 
    input x, 
    input y, 
    input z,
    output reg out);assign out = (~w & x & ~y & ~z) | (w & ~x & y & ~z) | (~w & x & ~y & z) | (w & x & y & z);

endmodule