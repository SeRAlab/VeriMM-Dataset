module matrix_factorization (  
    input clk,  
    input reset,  
    input [15:0] matrix_in_00,  
    input [15:0] matrix_in_01,  
    input [15:0] matrix_in_10,  
    input [15:0] matrix_in_11,  
    output reg [15:0] factor1_00,  
    output reg [15:0] factor1_01,  
    output reg [15:0] factor1_10,  
    output reg [15:0] factor1_11,  
    output reg [15:0] factor2_00,  
    output reg [15:0] factor2_01,  
    output reg [15:0] factor2_10,  
    output reg [15:0] factor2_11  
);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            factor1_00 <= 0;  
            factor1_01 <= 0;  
            factor1_10 <= 0;  
            factor1_11 <= 0;  
            factor2_00 <= 0;  
            factor2_01 <= 0;  
            factor2_10 <= 0;  
            factor2_11 <= 0;  
        end else begin  
            // Simple factorization logic  
            factor1_00 <= matrix_in_00 >> 1;  
            factor1_01 <= matrix_in_01 >> 1;  
            factor1_10 <= matrix_in_10 >> 1;  
            factor1_11 <= matrix_in_11 >> 1;  
            factor2_00 <= matrix_in_00 - factor1_00;  
            factor2_01 <= matrix_in_01 - factor1_01;  
            factor2_10 <= matrix_in_10 - factor1_10;  
            factor2_11 <= matrix_in_11 - factor1_11;  
        end  
    end  
endmodule