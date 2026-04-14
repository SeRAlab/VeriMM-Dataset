module pipeline_arithmetic (  
    input clk,  
    input [3:0] a,  
    input [3:0] b,  
    output reg [3:0] sum,  
    output reg [7:0] product  
);  
    reg [3:0] add_result;  
    always @(posedge clk) begin  
        add_result <= a + b;  
        sum <= add_result;  
        product <= add_result * 2;  
    end  
endmodule