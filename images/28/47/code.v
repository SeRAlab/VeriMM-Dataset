module LIFO_Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [7:0] stack [0:7]; // 8 element stack
    reg [2:0] top; // points to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b111; // Set to -1 (no elements)
            is_empty <= 1'b1;
            is_full <= 1'b0;
            data_out <= 8'b0;
        end else begin
            if (push && !is_full) begin
                top <= top + 1;
                stack[top] <= data_in;
                is_empty <= 1'b0;
                if (top == 3'b111) is_full <= 1'b1; // Check if stack is full
            end
            
            if (pop && !is_empty) begin
                data_out <= stack[top];
                top <= top - 1;
                if (top == 3'b111) is_empty <= 1'b1; // Stack is empty now
                is_full <= 1'b0;
            end
            
            if (!pop) begin
                data_out <= stack[top]; // Peek operation
            end
        end
    end
endmodule