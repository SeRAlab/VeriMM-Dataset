module top_module(en,in,seg);input [3:0] in;
input en;
output [7:0] seg;

reg [7:0] seg;
always@(en or in)

begin
 if (!en) seg=8'b11111111;
 else case(in)
 4'd0: seg=8'b00000011;
 4'd1: seg=8'b10011111;
 4'd2: seg=8'b00100101;
 4'd3: seg=8'b00001101;
 4'd4: seg=8'b10011001;
 4'd5: seg=8'b01001001;
 4'd6: seg=8'b01000001;
 4'd7: seg=8'b00011011;
 4'd8: seg=8'b00000001;
 4'd9: seg=8'b00001001;
 endcase
 end
 endmodule