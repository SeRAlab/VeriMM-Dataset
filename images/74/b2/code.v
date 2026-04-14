module top_module(
    input  wire x, y, 
    output wire z,
    output wire carry_out
);assign {carry_out, z} = x + y;
endmodule