module top_module(
  input [3:0] bcd,
  output reg [7:0] bin  // Change wire to reg
);always @(*) begin
    case(bcd)
      4'b0000: bin = 8'b00000000;
      4'b0001: bin = 8'b00000001;
      4'b0010: bin = 8'b00000010;
      4'b0011: bin = 8'b00000011;
      4'b0100: bin = 8'b00000100;
      4'b0101: bin = 8'b00000101;
      4'b0110: bin = 8'b00000110;
      4'b0111: bin = 8'b00000111;
      4'b1000: bin = 8'b00001000;
      4'b1001: bin = 8'b00001001;
      default: bin = 8'b00000000; // Changed to a defined state instead of 'z's
    endcase
  end

endmodule