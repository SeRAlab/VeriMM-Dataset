module top_module(
  input [2:0] in,
  output [1:0] out
);reg [1:0] sum;
  
  always @(*) begin
    case (in)
      3'b000: sum = 2'b00;
      3'b001: sum = 2'b01;
      3'b010: sum = 2'b01;
      3'b011: sum = 2'b10;
      3'b100: sum = 2'b01;
      3'b101: sum = 2'b10;
      3'b110: sum = 2'b10;
      3'b111: sum = 2'b11;
    endcase
    
    if (in[1] == 1'b1) begin
      sum = sum + 1;
    end
  end
  
  assign out = sum;
  
endmodule