module LIFO_stack #(parameter DEPTH = 8, parameter WIDTH = 8) (  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg empty,  
    output reg full  
);  
    reg [WIDTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] top;  // to keep track of the top index  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            empty <= 1;  
            full <= 0;  
            data_out <= 0;  
        end else begin  
            if (push && !full) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
                empty <= 0;  
                if (top + 1 == DEPTH) full <= 1;  
            end  
            if (pop && !empty) begin  
                top <= top - 1;  
                data_out <= stack[top];  
                if (top == 1) empty <= 1;  
                if (top < DEPTH) full <= 0;  
            end  
        end  
    end  
endmodule