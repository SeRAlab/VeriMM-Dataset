module LIFO_Stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack [0:15]; // 16 deep stack
    reg [3:0] top; // points to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 4'b0000;
            empty <= 1;
            full <= 0;
            data_out <= 8'b00000000;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
                empty <= 0;
                full <= (top + 1 == 16);
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top - 1];
                full <= 0;
                empty <= (top - 1 == 0);
            end
        end
    end
endmodule