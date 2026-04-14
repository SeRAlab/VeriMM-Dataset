module LIFO_stack #(parameter DATA_WIDTH = 4, parameter MAX_SIZE = 4) (
    input clk,
    input rst,
    input push,
    input pop,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg empty,
    output reg full
);
    reg [DATA_WIDTH-1:0] stack [0:MAX_SIZE-1];
    reg [1:0] top; // 2-bit for max size 4 (0 to 3)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
            end 
            if (pop && !empty) begin
                top <= top - 1;
            end 
            empty <= (top == 0);
            full <= (top == MAX_SIZE);
            data_out <= (top > 0) ? stack[top - 1] : 0; // Peek the top item
        end
    end
endmodule