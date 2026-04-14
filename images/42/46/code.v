module top_module(
  input clk,
  input reset,
  input d,
  output reg q
);reg [3:0] sr1;
  reg [1:0] sr2;

  always @(posedge clk) begin
    if (reset) begin
      sr1 <= 4'b0000;
      sr2 <= 2'b00;
    end else begin
      sr1 <= {sr1[2:0], sr1[3]};
      sr2 <= {sr2[0], d};
    end
  end

  assign q = sr1[0] ^ sr2[1];

endmodule