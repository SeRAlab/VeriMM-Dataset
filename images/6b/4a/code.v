module top_module(
    input clk,
    input rst,
    input push_i,
    input pop_i,
    input [dw-1:0] data_i,
    output [dw-1:0] data_o,
    output empty_o
);parameter dw = 8;
parameter stack_size = 8;

reg [dw-1:0] stack [0:stack_size-1];
reg top = 0;

always @(posedge clk)
begin
    if (rst)
        top <= 0;
    else if (push_i && (top < stack_size))
    begin
        stack[top] <= data_i;
        top <= top + 1;
    end
    else if (pop_i && (top > 0))
        top <= top - 1;
end

assign data_o = (top > 0) ? stack[top-1] : 0;
assign empty_o = (top == 0);

endmodule