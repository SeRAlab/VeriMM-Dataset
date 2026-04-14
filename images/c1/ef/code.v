module mux_2to1_enable (
  input enable,
  input [7:0] in1,
  input [7:0] in2,
  output reg [7:0] out
);

  always @(*) begin
    if (enable == 1'b0) begin
      out = in1;
    end else begin
      out = in2;
    end
  end

endmodule
