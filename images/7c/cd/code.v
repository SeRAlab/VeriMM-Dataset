module top_module(
  input clock,
  input clrn,
  input [0:0] d,
  output [0:0] q
);reg [0:0] dffe4a;
  reg [0:0] dffe5a;
  reg [0:0] dffe6a;

  always @(posedge clock or negedge clrn) begin
    if (!clrn) begin
      dffe4a <= 1'b0;
    end else begin
      dffe4a <= d;
    end
  end

  always @(posedge clock or negedge clrn) begin
    if (!clrn) begin
      dffe5a <= 1'b0;
    end else begin
      dffe5a <= dffe4a;
    end
  end

  always @(posedge clock or negedge clrn) begin
    if (!clrn) begin
      dffe6a <= 1'b0;
    end else begin
      dffe6a <= dffe5a;
    end
  end

  assign q = dffe6a;

  assign ena = 1'b1;
  assign prn = 1'b1;
  assign sclr = 1'b0;

endmodule