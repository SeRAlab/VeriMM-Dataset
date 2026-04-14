module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);reg [7:0] hi;
reg [7:0] lo;

always @(*) begin
    hi = in[15:8];
    lo = in[7:0];
end

assign out_hi = hi;
assign out_lo = lo;

endmodule