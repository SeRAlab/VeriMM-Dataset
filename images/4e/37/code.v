module top_module(
    input [7:0] A,
    input [7:0] B,
    output [7:0] sum,
    output carry_out
);wire [8:0] temp_sum;
    
    // Add A and B, store result in temp_sum
    assign temp_sum = {1'b0, A} + {1'b0, B};
    
    // Assign sum to the 8 least significant bits of temp_sum
    assign sum = temp_sum[7:0];
    
    // Assign carry_out to the most significant bit of temp_sum
    assign carry_out = temp_sum[8];
    
endmodule