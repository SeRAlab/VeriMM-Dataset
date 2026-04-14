module dfs_tree #(parameter WIDTH = 8, parameter DEPTH = 4) (  
    input clk,  
    input rst,  
    input [WIDTH-1:0] value,  
    input valid,  
    output reg [WIDTH-1:0] output_value,  
    output reg done  
);  
    reg [DEPTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] top;  
    integer i;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            done <= 0;  
        end else if (valid) begin  
            stack[top] <= value;  
            top <= top + 1;  
            done <= 0;  
        end else if (top > 0) begin  
            top <= top - 1;  
            output_value <= stack[top];  
            done <= 1;  
        end  
    end  
endmodule