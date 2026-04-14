module stack_lifo #(parameter DEPTH = 4, WIDTH = 4)  
(  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg overflow,  
    output reg underflow  
);  
    reg [WIDTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] top;  

    initial begin  
        top = 0;  
        overflow = 0;  
        underflow = 0;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            overflow <= 0;  
            underflow <= 0;  
        end else begin  
            if (push) begin  
                if (top < DEPTH) begin  
                    stack[top] <= data_in;  
                    top <= top + 1;  
                    overflow <= 0;  
                end else begin  
                    overflow <= 1;  
                end  
            end  
            if (pop) begin  
                if (top > 0) begin  
                    top <= top - 1;  
                    data_out <= stack[top];  
                    underflow <= 0;  
                end else begin  
                    underflow <= 1;  
                end  
            end  
        end  
    end  
endmodule