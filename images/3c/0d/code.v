module LIFO_Stack (
    input clk,
    input reset,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] stack [0:7];
    reg [2:0] top;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 3'b000;
            empty <= 1;
            full <= 0;
            data_out <= 8'b00000000;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top];
            end
            empty <= (top == 0);
            full <= (top == 8);
        end
    end
endmodule