module LIFO_stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] stack [0:15]; // 16 deep stack
    reg [3:0] top;           // points to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 4'b0000; // Reset stack pointer
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in; // Push data
                top <= top + 1;
                empty <= 1'b0;
                if (top + 1 == 16) 
                    full <= 1'b1; // Stack is full
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top]; // Pop data
                if (top == 1)
                    empty <= 1'b1; // Stack is empty
                full <= 1'b0;
            end
        end
    end
endmodule