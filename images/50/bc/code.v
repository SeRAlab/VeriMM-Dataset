module top_module(
  input [3:0] bcd_in,
  output reg [7:0] bin_out  // Change wire to reg
);always @ (bcd_in) begin
    case (bcd_in)
      4'd0: bin_out = 8'b00000000;
      4'd1: bin_out = 8'b00000001;
      4'd2: bin_out = 8'b00000010;
      4'd3: bin_out = 8'b00000011;
      4'd4: bin_out = 8'b00000100;
      4'd5: bin_out = 8'b00000101;
      4'd6: bin_out = 8'b00000110;
      4'd7: bin_out = 8'b00000111;
      4'd8: bin_out = 8'b00001000;
      4'd9: bin_out = 8'b00001001;
      default: bin_out = 8'b00000000;
    endcase
  end

endmodule