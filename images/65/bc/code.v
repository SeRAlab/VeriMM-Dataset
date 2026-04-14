module top_module(
  input [n-1:0] data_in,
  input [m-1:0] addr_in,
  input we,
  output [n-1:0] data_out,
  output wp
);parameter n = 8; // width of data input and output signals
parameter m = 4; // width of address input signals

reg [n-1:0] data_out_reg;
reg wp_reg;

always @(*) begin
  if (we == 1'b0) begin
    data_out_reg = data_in;
    wp_reg = 1'b0;
  end else begin
    case (addr_in)
      // Add protected addresses here
      // For example, to protect addresses 0x00 and 0x01:
      // 4'h0: wp_reg = 1'b1;
      // 4'h1: wp_reg = 1'b1;
      default: begin
        data_out_reg = data_in;
        wp_reg = 1'b0;
      end
    endcase
  end
end

assign data_out = data_out_reg;
assign wp = wp_reg;

endmodule