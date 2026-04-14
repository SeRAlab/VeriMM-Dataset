module pipelined_adder (  
    input clk,  
    input rst,  
    input [4:0] a,  
    input [4:0] b,  
    output reg [5:0] result  
);  

    reg [4:0] a_reg[0:4];  
    reg [4:0] b_reg[0:4];  
    reg [5:0] sum_reg[0:4];  

    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < 5; i = i + 1) begin  
                a_reg[i] <= 0;  
                b_reg[i] <= 0;  
                sum_reg[i] <= 0;  
            end  
            result <= 0;  
        end else begin  
            a_reg[0] <= a;  
            b_reg[0] <= b;  

            // Stage 1: Fetch  
            a_reg[1] <= a_reg[0];  
            b_reg[1] <= b_reg[0];  

            // Stage 2: Decode  
            sum_reg[2] <= a_reg[1] + b_reg[1];  

            // Stage 3: Execute  
            sum_reg[3] <= sum_reg[2];  

            // Stage 4: Memory Access  
            sum_reg[4] <= sum_reg[3];  

            // Stage 5: Write Back  
            result <= sum_reg[4];  
        end  
    end  
endmodule