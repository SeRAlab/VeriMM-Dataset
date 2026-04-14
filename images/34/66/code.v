module pipelined_multiplier (  
    input clk,  
    input rst,  
    input [7:0] a,  
    input [7:0] b,  
    output reg [15:0] product  
);  

    reg [7:0] a_reg [0:6];  
    reg [7:0] b_reg [0:6];  
    reg [15:0] mult_reg [0:6];  

    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            product <= 16'b0;  
            for (i = 0; i < 7; i = i + 1) begin  
                a_reg[i] <= 8'b0;  
                b_reg[i] <= 8'b0;  
                mult_reg[i] <= 16'b0;  
            end  
        end else begin  
            a_reg[0] <= a;  
            b_reg[0] <= b;  
            for (i = 1; i < 7; i = i + 1) begin  
                a_reg[i] <= a_reg[i-1];  
                b_reg[i] <= b_reg[i-1];  
                mult_reg[i] <= mult_reg[i-1];  
            end  
            mult_reg[0] <= a_reg[0] * b_reg[0];  
            product <= mult_reg[6];  
        end  
    end  
endmodule