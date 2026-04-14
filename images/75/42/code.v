module top_module(
  input [15:0] in,
  input [3:0] ctrl,
  output reg [15:0] out  // Change to reg type
);always @(*) begin
    case(ctrl)
      4'b0000: out = {in[14:0], 1'b0};
      4'b0001: out = {1'b0, in[15:1]};
      4'b0010: out = in + 1;
      4'b0011: out = in - 1;
      4'b0100: out = in & 16'h00FF;
      4'b0101: out = in | 16'hFF00;
      4'b0110: out = in ^ 16'hFFFF;
      4'b0111: out = ~in;
      4'b1000: out = in;
      4'b1001: out = 16'h0000;
      4'b1010: out = 16'hFFFF;
      4'b1011: out = {15'b0, in[0]};  // Ensure output is 16 bits
      4'b1100: out = {15'b0, in[15]}; // Ensure output is 16 bits
      4'b1101: out = {15'b0, in[ctrl[3:2]]}; // Ensure output is 16 bits
      4'b1110: out = {15'b0, in[ctrl[1:0]]}; // Ensure output is 16 bits
      default: out = 16'h0000;
    endcase
  end

endmodule