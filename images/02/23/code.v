module LIFO_stack #(parameter DEPTH = 8) (  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [3:0] data_in,  
    output reg [3:0] data_out,  
    output reg empty  
);  
    reg [3:0] stack [0:DEPTH-1];  
    reg [2:0] top;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            empty <= 1;  
        end else begin  
            if (push && top < DEPTH) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
                empty <= (top + 1 == DEPTH) ? 0 : 1;  
            end  
            if (pop && top > 0) begin  
                top <= top - 1;  
                data_out <= stack[top];  
                empty <= (top - 1 == 0) ? 1 : 0;  
            end  
        end  
    end  
endmodule