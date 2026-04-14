module mux2to1_active_low (
  input [1:0] in0,
  input [1:0] in1,
  input sel,
  input en_n,
  output reg [1:0] out
);

  always @(*) begin
    if (~en_n) begin
      case (sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 2'b0;
      endcase
    end else begin
      out = 2'b0;
    end
  end

endmodule