module LIFO_stack #(parameter DEPTH = 8, parameter WIDTH = 8) (
    input clk,
    input rst,
    input push,
    input pop,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [WIDTH-1:0] stack [0:DEPTH-1];
    reg [3:0] top; // Points to the index of the top element

    initial begin
        top = 0;
        is_empty = 1;
        is_full = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            is_empty <= 1;
            is_full <= 0;
        end else begin
            if (push && !is_full) begin
                stack[top] <= data_in;
                top <= top + 1;
                is_empty <= 0;
                if (top + 1 == DEPTH) 
                    is_full <= 1;
            end
            if (pop && !is_empty) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 1) 
                    is_empty <= 1;
                is_full <= 0;
            end
        end
    end
endmodule