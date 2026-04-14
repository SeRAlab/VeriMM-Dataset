module LIFO_stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] stack [0:3];
    reg [1:0] top; // points to the top of the stack

    initial begin
        top = 2'b00;
        full = 1'b0;
        empty = 1'b1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
                if (top == 2'b11) full <= 1'b1; // stack is full
                empty <= 1'b0;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 2'b00) empty <= 1'b1; // stack is empty
                full <= 1'b0;
            end
        end
    end
endmodule