module LIFO_Stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] stack [0:3];
    reg [1:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                if (top == 2'b11) begin
                    full <= 1'b1;
                end
                top <= top + 1;
                empty <= 1'b0;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 2'b00) begin
                    empty <= 1'b1;
                end
                full <= 1'b0;
            end
        end
    end
endmodule