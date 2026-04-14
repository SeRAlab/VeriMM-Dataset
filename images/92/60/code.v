module top_module(
  input clk,
  input [3:0] bin_num,
  output reg [2:0] dec_num
);reg [2:0] temp_dec_num;

always @(posedge clk) begin
  temp_dec_num = 0;
  case (bin_num)
    4'b0000: temp_dec_num = 3'b000;
    4'b0001: temp_dec_num = 3'b001;
    4'b0010: temp_dec_num = 3'b010;
    4'b0011: temp_dec_num = 3'b011;
    4'b0100: temp_dec_num = 3'b100;
    4'b0101: temp_dec_num = 3'b101;
    4'b0110: temp_dec_num = 3'b110;
    4'b0111: temp_dec_num = 3'b111;
    4'b1000: temp_dec_num = 3'b000;
    4'b1001: temp_dec_num = 3'b001;
    4'b1010: temp_dec_num = 3'b010;
    default: temp_dec_num = 3'b000;
  endcase
end

always @(posedge clk) begin
  if (bin_num === 4'b0000 || bin_num === 4'b1000) begin
    dec_num <= temp_dec_num;
  end
end

endmodule