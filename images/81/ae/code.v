module top_module(
    input [3:0] A,
    input [3:0] B,
    input C_in,
    output [3:0] S,
    output C_out
);wire [4:0] temp_sum;
    
    // Generate the sum for each bit
    assign temp_sum = {C_in, A} + {C_in, B};
    
    // Assign the 4-bit sum output
    assign S = temp_sum[3:0];
    
    // Assign the carry-out output
    assign C_out = temp_sum[4];
    
endmodule