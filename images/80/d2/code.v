module top_module(
    input clk, rst, en,
    input [3:0] din,
    output [3:0] dout
);reg [3:0] reg_out;

always @(negedge clk) begin
    if (rst) begin
        reg_out <= 4'b0;
    end else if (en) begin
        reg_out <= din;
    end
end

assign dout = reg_out;

endmodule