module top_module(
    input clk,
    input rst_n,
    input [3:0] din,
    output [3:0] dout
);reg [3:0] state;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 4'b0;
    end else begin
        state <= din;
    end
end

assign dout = state;

endmodule