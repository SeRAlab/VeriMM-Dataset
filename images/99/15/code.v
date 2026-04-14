module top_module(
  input CLK, EN, TE,
  input [31:0] W,
  output reg ENCLK,
  output reg [31:0] Y
);always @ (posedge CLK) begin
    if (TE) begin
      ENCLK <= CLK;
    end else begin
      ENCLK <= EN ? CLK : 1'b0;
    end
  end

  always @ (posedge ENCLK) begin
    Y <= W;
  end

endmodule