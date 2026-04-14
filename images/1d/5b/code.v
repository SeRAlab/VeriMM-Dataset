module pipelined_adder(  
    input clk,  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] Sum  
);  
    reg [7:0] stage1_sum;  

    always @(posedge clk) begin  
        stage1_sum <= A + B;  
        Sum <= stage1_sum;  
    end  
endmodule