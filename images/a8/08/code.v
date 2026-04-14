module top_module(
    input clk,                // Added clock input
    input [0:0] in,
    output reg [2:0] out
);reg [2:0] reg_out;

always @(posedge clk) begin
    reg_out <= {reg_out[1:0], in};
end

assign out = reg_out & 3'b111;

endmodule