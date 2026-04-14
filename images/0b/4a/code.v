module LIFO_Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] stack [3:0]; // 4 depth stack
    reg [1:0] top; // stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (push) begin
                if (top < 2'b11) begin
                    stack[top] <= data_in;
                    top <= top + 1;
                    empty <= 1'b0;
                end
            end
            if (pop) begin
                if (top > 0) begin
                    top <= top - 1;
                    data_out <= stack[top];
                    if (top == 1) empty <= 1'b1;
                end
            end
        end
    end
endmodule