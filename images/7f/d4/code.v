module top_module(
  input clock,
  input clrn,
  input [0:0] d,
  output [0:0] q
);reg [0:0] dffe4a;
  reg [0:0] dffe5a;
  reg [0:0] dffe6a;
  wire ena = 1'b1;
  wire prn = 1'b1;
  wire sclr = 1'b0;

  always @ (posedge clock, negedge prn, negedge clrn) begin
    if (~prn) begin
      dffe4a <= 1'b1;
    end else if (~clrn) begin
      dffe4a <= 1'b0;
    end else if (ena) begin
      dffe4a <= d & (~sclr);
    end
  end

  always @ (posedge clock, negedge prn, negedge clrn) begin
    if (~prn) begin
      dffe5a <= 1'b1;
    end else if (~clrn) begin
      dffe5a <= 1'b0;
    end else if (ena) begin
      dffe5a <= dffe4a & (~sclr);
    end
  end

  always @ (posedge clock, negedge prn, negedge clrn) begin
    if (~prn) begin
      dffe6a <= 1'b1;
    end else if (~clrn) begin
      dffe6a <= 1'b0;
    end else if (ena) begin
      dffe6a <= dffe5a & (~sclr);
    end
  end

  assign q = dffe6a;

endmodule