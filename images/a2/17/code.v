module top_module(
    input  [7:0] A,
    input  [7:0] B,
    output reg  [7:0] a,
    output  reg [7:0] b,
    input  start
    );reg [7:0] temp;
  always @(posedge start)
   begin
   if(start==1) begin
   a<=b;
   b<=a;
   end
   end
   always @(A,B)
   begin 
   a<=A;
   b<=B;
    end

endmodule