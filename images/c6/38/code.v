module constant_output(
  input [31:0] din,
  input control,
  output reg [31:0] dout
);

always @(*) begin
  if (control == 1'b0) begin
    dout = 32'b0;
  end else begin
    dout = 32'b1;
  end
end

endmodule