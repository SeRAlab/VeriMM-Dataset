module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] sel,
    output reg [3:0] out
    );always @*
    begin
      case(sel)
        2'b00 : out = A & B;
        2'b01 : out = A | B;
        2'b10 : out = A ^ B;
        2'b11 : out = ~(A ^ B);
        default : out = 4'b0;
      endcase
    end
  
endmodule