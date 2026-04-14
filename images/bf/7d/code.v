module top_module(
  input clk_in,
  input reset_in,
  input [n-1:0] data_in,
  output reg [n-1:0] data_out,
  output reg valid_out
);parameter n = 8; // number of bits in the data signal

reg [1:0] sync_reg1;
reg [1:0] sync_reg2;

always @(posedge clk_in) begin
  sync_reg1 <= {sync_reg1[0], data_in};
  sync_reg2 <= {sync_reg2[0], sync_reg1[1]};
end

always @(posedge clk_in, posedge reset_in) begin
  if (reset_in) begin
    data_out <= 'b0;
    valid_out <= 1'b0;
  end else begin
    data_out <= sync_reg2[1];
    valid_out <= sync_reg2[0] & ~sync_reg1[0];
  end
end

endmodule