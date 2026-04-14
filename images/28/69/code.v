module LIFO_stack (
    input wire clk,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    parameter DEPTH = 8;
    reg [7:0] stack[0:DEPTH-1];
    reg [3:0] top;

    initial begin
        top = 0;
        empty = 1;
        full = 0;
    end

    always @(posedge clk) begin
        if (push && !full) begin
            stack[top] = data_in;
            top = top + 1;
            empty = (top == 1);
            full = (top == DEPTH);
        end
        else if (pop && !empty) begin
            top = top - 1;
            data_out = stack[top];
            empty = (top == 0);
            full = (top == DEPTH);
        end
    end
endmodule