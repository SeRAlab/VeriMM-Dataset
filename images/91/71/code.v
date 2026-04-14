module top_module(input clk, input [7:0] D, input EI, output reg [7:0] Q);wire CLK;
assign CLK=(clk & EI);
always @(posedge CLK)
begin
    Q <= D;
end
endmodule