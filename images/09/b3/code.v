module pipelined_adder(  
    input clk,  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] sum  
);  
    reg [7:0] stage1_a;  
    reg [7:0] stage1_b;  
    reg [7:0] stage2_sum;  

    always @(posedge clk) begin  
        // Stage 1: Capture inputs  
        stage1_a <= a;  
        stage1_b <= b;  
        // Stage 2: Calculate sum  
        stage2_sum <= stage1_a + stage1_b;  
        sum <= stage2_sum;  
    end  
endmodule