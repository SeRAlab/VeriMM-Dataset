module SignExt (
  input [15:0] in,
  output reg [31:0] out
);

  always @(*) begin
    if (in[15] == 1) begin
      out = {16'b1111_1111_1111_1111, in};
    end else begin
      out = {16'b0000_0000_0000_0000, in};
    end
  end

endmodule