module wallace_tree_multiplier  
(  
    input [3:0] a,  
    input [3:0] b,  
    output reg [7:0] product  
);  
  
    wire [3:0] pp [3:0]; // partial products  
  
    // Generate partial products  
    assign pp[0] = a & {4{b[0]}};  
    assign pp[1] = a & {4{b[1]}} << 1;  
    assign pp[2] = a & {4{b[2]}} << 2;  
    assign pp[3] = a & {4{b[3]}} << 3;  
  
    wire [4:0] sum1, sum2;  
    wire [4:0] carry;  
  
    // First reduction stage  
    assign sum1 = pp[0] + pp[1];  
    assign carry[0] = sum1[4];  
    assign sum2 = pp[2] + pp[3];  
    assign carry[1] = sum2[4];  
    assign carry[2] = carry[0];  
    assign carry[3] = carry[1];  
  
    // Second reduction stage  
    wire [5:0] final_sum;  
    assign final_sum = sum1[3:0] + sum2[3:0] + carry[1:0];  
  
    // Final product  
    always @(*) begin  
        product = {final_sum[4:0], pp[0][3:0]} + {carry[3:0], 4'b0000};  
    end  
  
endmodule