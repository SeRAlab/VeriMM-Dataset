module fixed_point_adder (
    input [7:0] a, // first 8-bit fixed-point input
    input [7:0] b, // second 8-bit fixed-point input
    output [7:0] sum // output 8-bit fixed-point sum
);
    wire signed [8:0] sum_temp; // temporary 9-bit wide sum to handle overflow
    assign sum_temp = a + b;
    
    // Saturate logic: if sum exceeds maximum 8-bit fixed-point value, cap at maximum
    assign sum = (sum_temp > 8'b01111111) ? 8'b01111111 : 
                 (sum_temp < 8'b10000000) ? 8'b10000000 : 
                 sum_temp[7:0];
endmodule