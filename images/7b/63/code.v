module top_module(
  input signed [31:0] in,
  input [1:0] dir,
  input [4:0] shift_amt,
  input [1:0] shift_type,
  output signed [31:0] out
);reg signed [31:0] shifted;

  always @(*) begin
    if (dir == 0) begin
      if (shift_type == 0) begin
        shifted = in << shift_amt;
      end else begin
        shifted = $signed(in) << shift_amt;
      end
    end else begin
      if (shift_type == 0) begin
        shifted = in >> shift_amt;
      end else begin
        shifted = $signed(in) >>> shift_amt;
      end
    end
  end

  assign out = shifted;

endmodule