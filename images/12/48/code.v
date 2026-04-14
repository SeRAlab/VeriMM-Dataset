module LIFO_Stack #(parameter DEPTH = 8)(
    input clk,
    input reset,
    input push,
    input pop,
    input [7:0] push_data,
    output reg [7:0] pop_data,
    output reg empty,
    output reg full
);
    reg [7:0] stack [0:DEPTH-1];
    reg [3:0] top;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 0;
            empty <= 1;
            full <= 0;
            pop_data <= 0;
        end else begin
            if (push && !full) begin
                stack[top] <= push_data;
                top <= top + 1;
            end
            if (pop && !empty) begin
                top <= top - 1;
                pop_data <= stack[top];
            end
            empty <= (top == 0);
            full <= (top == DEPTH);
        end
    end
endmodule