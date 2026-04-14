module top_module(
  // inputs:
  address,
  clock,
  reset_n,

  // outputs:
  readdata
);output [31:0] readdata;
  input [31:0] address;
  input clock;
  input reset_n;

  reg [31:0] readdata_reg;

  always @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      readdata_reg <= 32'h0;
    end else begin
      readdata_reg <= (address == 32'h0) ? 32'hff : 32'h590d8d31;
    end
  end

  assign readdata = readdata_reg;

endmodule