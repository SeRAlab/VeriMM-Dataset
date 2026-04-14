module LIFO_stack #(
    parameter STACK_SIZE = 8,
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input push,
    input pop,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg empty,
    output reg full
);

reg [DATA_WIDTH-1:0] stack [0:STACK_SIZE-1];
reg [3:0] top;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        top <= 0;
        empty <= 1;
        full <= 0;
    end else begin
        if (push && !full) begin
            stack[top] <= data_in;
            top <= top + 1;
        end
        if (pop && !empty) begin
            top <= top - 1;
            data_out <= stack[top];
        end
        empty <= (top == 0);
        full <= (top == STACK_SIZE);
    end
end

endmodule