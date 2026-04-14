module top_module(
    input [4:0] in,
    output reg [4:0] out
    );always @(*)
begin
 casex(in)
    5'b1xxxx: out=5'b10000;
    5'b01xxx: out=5'b01000;
    5'b001xx: out=5'b00100;
    5'b0001x: out=5'b00010;
    5'b00001: out=5'b00001;
    5'b00000: out=5'b00000;
  endcase  
end
endmodule