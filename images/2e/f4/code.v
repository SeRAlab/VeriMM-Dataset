module LIFO_Stack #(parameter SIZE = 8) (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] stack [0:SIZE-1];
    reg [3:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 4'd0;
            empty <= 1'b1;
            data_out <= 8'd0;
        end else begin
            if (push && (top < SIZE)) begin
                stack[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0;
            end
            if (pop && (top > 0)) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 1)
                    empty <= 1'b1;
            end
        end
    end
endmodule