module LIFO_Stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg is_empty,
    output reg is_full
);

    reg [7:0] stack [0:7];
    reg [2:0] top; // points to the top of the stack

    initial begin
        top = 3'b000;
        is_empty = 1;
        is_full = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b000;
            is_empty <= 1;
            is_full <= 0;
        end else begin
            if (push && !is_full) begin
                stack[top] <= data_in;
                top <= top + 1;
            end
            if (pop && !is_empty) begin
                top <= top - 1;
                data_out <= stack[top];
            end
            is_empty <= (top == 0);
            is_full <= (top == 8);
        end
    end
endmodule