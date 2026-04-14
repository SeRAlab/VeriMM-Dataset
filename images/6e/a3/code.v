module top_module(
  input [3:0] A,
  input [3:0] B,
  input [3:0] C,
  input VPWR,
  input VGND,
  input VPB,
  input VNB,
  output reg [3:0] X
);reg [3:0] result;

  always @(*) begin
    result = A + B - C;
    if (result < 0) begin
      X = 4'b0000;
    end else begin
      X = result;
    end
  end

  assign VPWR = 1'b1;
  assign VGND = 1'b0;
  assign VPB = 1'b1;
  assign VNB = 1'b0;

endmodule