module top_module(
    input [3:0] A,
    input [3:0] B,
    input S,
    output [3:0] Y,
    output V
);wire [4:0] sum;
    wire signed [3:0] A_signed;
    wire signed [3:0] B_signed;
    
    // Convert inputs to signed if necessary
    assign A_signed = ({1'b0, A} - (S ? 8'b10000000 : 0));
    assign B_signed = ({1'b0, B} - (S ? 8'b10000000 : 0));
    
    // Calculate sum
    assign sum = A_signed + B_signed;
    
    // Determine overflow
    assign V = (S ? (sum[4] != sum[3]) : (sum[4] == 1));
    
    // Output sum
    assign Y = sum[3:0];
    
endmodule