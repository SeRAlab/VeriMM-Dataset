module top_module(
  input [3:0] binary_input,
  output reg [15:0] bcd_output
);always @(*) begin
    case (binary_input)
      4'b0000: bcd_output = 16'b0000_0000_0000_0000;
      4'b0001: bcd_output = 16'b0000_0000_0000_0001;
      4'b0010: bcd_output = 16'b0000_0000_0000_0010;
      4'b0011: bcd_output = 16'b0000_0000_0000_0011;
      4'b0100: bcd_output = 16'b0000_0000_0000_0100;
      4'b0101: bcd_output = 16'b0000_0000_0000_0101;
      4'b0110: bcd_output = 16'b0000_0000_0000_0110;
      4'b0111: bcd_output = 16'b0000_0000_0000_0111;
      4'b1000: bcd_output = 16'b0000_0000_0001_0000;
      4'b1001: bcd_output = 16'b0000_0000_0001_0001;
      default: bcd_output = 16'b0000_0000_0000_0000;
    endcase
  end

endmodule