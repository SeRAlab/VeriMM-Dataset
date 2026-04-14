module top_module(
    input clk,
    input [7:0] d1,
    input [7:0] d2,
    input sel,
    output [7:0] q
);reg [7:0] q_reg;
wire [7:0] d_in;

assign d_in = sel ? d2 : d1;

always @(negedge clk) begin
    q_reg <= d_in;
end

assign q = q_reg;

endmodule