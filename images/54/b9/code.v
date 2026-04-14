module top_module(
    input x_in,        // input bit
    input y_in,        // input bit
    output s_out,      // sum output
    output c_out       // carry output
);assign s_out = x_in ^ y_in; // Sum is XOR of the two inputs
    assign c_out = x_in & y_in; // Carry is AND of the two inputs
endmodule