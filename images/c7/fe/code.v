module sum_4_bits (input [15:0] in, output reg [3:0] out);

  always @(*) begin
    out = in[15:12] + in[3:0];
  end

endmodule