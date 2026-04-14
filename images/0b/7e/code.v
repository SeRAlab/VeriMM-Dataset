module pipelined_adder(  
    input clk,  
    input reset,  
    input [7:0] a,  
    input [7:0] b,  
    output reg [8:0] result  
);  
    reg [8:0] stage1_result;  
    wire [8:0] stage2_input;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            stage1_result <= 9'b0;  
            result <= 9'b0;  
        end else begin  
            stage1_result <= a + b;  
            result <= stage1_result + 9'b000000101; // Adding 5  
        end  
    end  
endmodule