module LIFO_Stack #(parameter DEPTH = 8) (  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    input push,  
    input pop,  
    output reg [3:0] data_out,  
    output reg empty  
);  
    reg [3:0] stack [0:DEPTH-1];  
    reg [3:0] stack_ptr;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stack_ptr <= 0;  
            empty <= 1;  
        end else begin  
            if (push && stack_ptr < DEPTH) begin  
                stack[stack_ptr] <= data_in;  
                stack_ptr <= stack_ptr + 1;  
                empty <= 0;  
            end  
            if (pop && stack_ptr > 0) begin  
                stack_ptr <= stack_ptr - 1;  
                data_out <= stack[stack_ptr - 1];  
                if (stack_ptr - 1 == 0)  
                    empty <= 1;  
            end  
        end  
    end  
endmodule