module LIFO_Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg is_empty
);
    reg [7:0] stack [0:7]; // Stack with 8 elements
    reg [2:0] top; // Pointer to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b000;
            is_empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (push && top < 3'b111) begin
                stack[top] <= data_in;
                top <= top + 1;
                is_empty <= 1'b0;
            end
            if (pop && top > 3'b000) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 1) begin
                    is_empty <= 1'b1;
                end
            end
            if (!push && !pop && top > 0) begin
                data_out <= stack[top - 1]; // Peek operation
            end
        end
    end
endmodule