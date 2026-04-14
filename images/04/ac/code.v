module LIFO_Stack (
    input clk,
    input rst,
    input [7:0] data_in,
    input push,
    input pop,
    output reg [7:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [7:0] stack [7:0];
    reg [2:0] top;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b000;
            is_empty <= 1'b1;
            is_full <= 1'b0;
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