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
    reg [7:0] stack [0:7]; // Stack array of size 8
    reg [2:0] top; // Points to the top of the stack

    initial begin
        top = 3'b111; // Stack is empty
        full = 1'b0; 
        empty = 1'b1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 3'b111; // Reset the stack
            full <= 1'b0; 
            empty <= 1'b1;
        end else begin
            if (push && !full) begin
                top <= top + 1; // Increment top
                stack[top] <= data_in; // Push data
                empty <= 1'b0; // Stack is not empty
                if (top == 3'b111) full <= 1'b1; // Check if stack is full
            end

            if (pop && !empty) begin
                data_out <= stack[top]; // Pop data
                top <= top - 1; // Decrement top
                full <= 1'b0; // Stack is not full
                if (top == 3'b111) empty <= 1'b1; // Check if stack is empty
            end
        end
    end
endmodule