module LIFO_Stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg overflow,
    output reg underflow
);
    reg [7:0] stack [3:0]; // Stack of depth 4
    reg [1:0] top; // Pointer to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            overflow <= 1'b0;
            underflow <= 1'b0;
            data_out <= 8'b0;
        end else begin
            overflow <= 1'b0;
            underflow <= 1'b0;

            if (push) begin
                if (top < 2'b11) begin // If stack is not full
                    stack[top] <= data_in;
                    top <= top + 1;
                end else begin
                    overflow <= 1'b1; // Stack overflow
                end
            end

            if (pop) begin
                if (top > 0) begin // If stack is not empty
                    top <= top - 1;
                    data_out <= stack[top-1];
                end else begin
                    underflow <= 1'b1; // Stack underflow
                end
            end
        end
    end
endmodule