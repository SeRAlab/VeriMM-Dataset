module LIFO_Stack #(parameter SIZE = 8, parameter DATA_WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [DATA_WIDTH-1:0] stack [0:SIZE-1];
    reg [3:0] top_index;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top_index <= 0;
            is_empty <= 1;
            is_full <= 0;
        end else begin
            if (push && !is_full) begin
                stack[top_index] <= data_in;
                top_index <= top_index + 1;
            end
            if (pop && !is_empty) begin
                top_index <= top_index - 1;
                data_out <= stack[top_index];
            end
            
            is_empty <= (top_index == 0);
            is_full <= (top_index == SIZE);
        end
    end
endmodule