module LIFO_Stack #(parameter SIZE = 8, WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg empty
);

    reg [WIDTH-1:0] stack [0:SIZE-1];
    reg [3:0] top; // pointer to the top of the stack

    initial begin
        top = 0;
        empty = 1;
        data_out = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            empty <= 1;
            data_out <= 0;
        end else begin
            if (push && top < SIZE) begin
                stack[top] <= data_in;
                top <= top + 1;
                empty <= (top + 1 == 1);
            end
            if (pop && top > 0) begin
                top <= top - 1;
                data_out <= stack[top];
                empty <= (top == 1);
            end
        end
    end
endmodule