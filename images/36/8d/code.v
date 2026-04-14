module stack_lifo #(parameter DEPTH = 8, WIDTH = 8) (  
    input wire clk,  
    input wire reset,  
    input wire push,  
    input wire pop,  
    input wire [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg empty  
);  
    reg [WIDTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] top;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            top <= 0;  
            empty <= 1;  
            data_out <= 0;  
        end else begin  
            if (push && top < DEPTH) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
                empty <= (top + 1 == 1);  
            end  
            if (pop && top > 0) begin  
                top <= top - 1;  
                data_out <= stack[top - 1];  
                empty <= (top - 1 == 0);  
            end  
        end  
    end  
endmodule