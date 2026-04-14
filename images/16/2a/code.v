module LIFO_stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty,
    output reg [1:0] depth
);
    reg [7:0] stack [3:0]; // Stack of 4 elements
    reg [1:0] top; // Points to the current top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            full <= 1'b0;
            empty <= 1'b1;
            depth <= 2'b00;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
                if (top == 2'b11) full <= 1'b1; // Stack is full
                empty <= 1'b0; // Stack is not empty
                depth <= top + 1; // Update depth
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 2'b00) empty <= 1'b1; // Stack is empty
                full <= 1'b0; // Stack is not full
                depth <= top; // Update depth
            end
        end
    end
endmodule