module pipelined_adder (  
    input clk,  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] S  
);  
    reg [7:0] A_reg, B_reg;  
    reg [7:0] sum_reg;  

    always @(posedge clk) begin  
        A_reg <= A;  
        B_reg <= B;  
        sum_reg <= A_reg + B_reg;  
        S <= sum_reg;  
    end  
endmodule