module LIFO_Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg is_empty
);
    parameter SIZE = 8;
    reg [7:0] stack [0:SIZE-1];
    reg [3:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            is_empty <= 1;
            data_out <= 8'b0;
        end else begin
            if (push && (top < SIZE)) begin
                stack[top] <= data_in;
                top <= top + 1;
                is_empty <= (top + 1 == 1) ? 0 : is_empty;
            end
            if (pop && (top > 0)) begin
                top <= top - 1;
                data_out <= stack[top];
                is_empty <= (top == 1) ? 1 : is_empty;
            end else if (!pop) begin
                data_out <= (top > 0) ? stack[top-1] : 8'b0;
            end
        end
    end
endmodule