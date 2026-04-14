module top_module(
  input [2:0] in,
  output [7:0] out
);reg [7:0] out_reg;
  
  always @(*) begin
    case(in)
      3'b000: out_reg = 8'b00000001;
      3'b001: out_reg = 8'b00000010;
      3'b010: out_reg = 8'b00000100;
      3'b011: out_reg = 8'b00001000;
      3'b100: out_reg = 8'b00010000;
      3'b101: out_reg = 8'b00100000;
      3'b110: out_reg = 8'b01000000;
      3'b111: out_reg = 8'b10000000;
      default: out_reg = 8'b00000000;
    endcase
  end
  
  assign out = out_reg;
  
endmodule