module top_module(value, cout, reset, clk);parameter NBITS = 4;

output reg [NBITS-1:0] value = {NBITS{1'b0}};
output wire cout;
input wire reset, clk;

assign cout = value == {NBITS{1'b1}};

always @(posedge clk)
begin
    if (reset) value = {NBITS{1'b0}};
    else value <= value + 1'b1;
end

endmodule