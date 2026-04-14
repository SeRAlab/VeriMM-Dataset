module mux2to1_enable (
  input [7:0] in0,
  input [7:0] in1,
  input sel,
  input en,
  output reg [7:0] out
);

  always @(*) begin
    if (en) begin
      case (sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 8'b0;
      endcase
    end else begin
      out = 8'b0;
    end
  end

endmodule