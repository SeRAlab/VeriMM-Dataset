module light_control (
  input [11:0] als,
  input [11:0] dll,
  input en,
  output reg [7:0] dim
);

  always @(*) begin
    if (en) begin
      if (als <= dll) begin
        dim <= 8'b00000000;
      end else begin
        dim <= ((als - dll) >> 4) > 8'b11111111 ? 8'b11111111 : ((als - dll) >> 4);
      end
    end else begin
      dim <= 8'b00000000;
    end
  end

endmodule