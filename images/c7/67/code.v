module twos_complement(
  input [3:0] in,
  output reg [3:0] out
);

  always @(*) begin
    if (in[3] == 1) begin
      out = ~(in) + 1;
    end else begin
      out = in;
    end
  end

endmodule