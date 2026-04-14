module top_module(
	input clk,
    input [2:0] A,
    input [2:0] B,
	input cm1,
	output reg [2:0] S,
	output reg c2,
	output reg OV,
	output reg c2final,
	output reg [3:0] digit
	);reg [2:0] AA;
	reg c0;
	reg c1;
	always @(posedge clk)	
	begin
         AA[0]<=A[0]^cm1;
         AA[1]<=A[1]^cm1;	 
         AA[2]<=A[2]^cm1;
         c0<=(AA[0]&B[0]) | (AA[0]|B[0])&cm1;
         c1<=(AA[1]&B[1]) | (AA[1]|B[1])&c0;
         c2<=(AA[2]&B[2]) | (AA[2]|B[2])&c1;
         S[0]<=AA[0]^B[0]^cm1;
         S[1]<=AA[1]^B[1]^c0;
         S[2]<=AA[2]^B[2]^c1;
         OV<=c2^c1;
         c2final<=OV&(~S[2]);
         if (OV==1)
         begin
           digit<={c2final,S[2:0]};
         end
         else
         begin
           digit<={S[2],S[2:0]};
         end	
    end
endmodule