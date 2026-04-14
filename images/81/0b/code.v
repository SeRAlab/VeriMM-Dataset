module top_module(
    input clk,
    input rst,
    input [7:0] r_in,
    input [7:0] g_in,
    input [7:0] b_in,
    output [7:0] r_out,
    output [7:0] g_out,
    output [7:0] b_out
);reg [7:0] r_internal;
reg [7:0] g_internal;
reg [7:0] b_internal;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        r_internal <= 8'b0;
        g_internal <= 8'b0;
        b_internal <= 8'b0;
    end else begin
        r_internal <= r_in - 8'h0A;
        g_internal <= g_in + 8'h0F;
        b_internal <= b_in * 8'h02;
    end
end

assign r_out = r_internal;
assign g_out = g_internal;
assign b_out = b_internal;

endmodule