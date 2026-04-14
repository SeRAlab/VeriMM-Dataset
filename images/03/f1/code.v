module LIFO_Stack (
    input clk,
    input rst,
    input [7:0] data_in,
    input push,
    input pop,
    output reg [7:0] top,
    output reg is_empty
);
    reg [7:0] stack [3:0]; // stack of depth 4
    reg [1:0] top_index;   // points to the current top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top_index <= 2'b00;
            is_empty <= 1;
            top <= 8'b0;
        end else begin
            if (push && top_index < 2'b11) begin
                stack[top_index] <= data_in;
                top_index <= top_index + 1;
                is_empty <= 0;
            end
            if (pop && top_index > 2'b00) begin
                top_index <= top_index - 1;
                top <= stack[top_index - 1];
                // Optionally clear the value after pop
                stack[top_index - 1] <= 8'b0;
                if (top_index == 2'b01) begin
                    is_empty <= 1;
                end
            end
            if (top_index > 0) begin
                top <= stack[top_index - 1];
            end
        end
    end
endmodule