module top_module(Cin, A, B, S,Cout);input Cin;
input [1:0] A;
input [1:0] B;
output  [1:0] S;
output  Cout;
reg [3:0] s;

always @(A,B,Cin)
case(B)
  0:
     begin
	     case ({A[1:0], Cin})
		  0:s=3'd0;
		  1,2:s=3'd1;
		  3,4:s=3'd2;
		  5,6:s=3'd3;
		  7:s=3'd4;
	     endcase
     end 
  1:
    begin
	 case({A[1:0], Cin})
		  0:s=3'd1;
		  1,2:s=3'd2;
		  3,4:s=3'd3;
		  5,6:s=3'd4;
		  7:s=3'd5;
	 endcase
    end
  2:
    begin
	 case({A[1:0], Cin})
		  0:s=3'd2;
		  1,2:s=3'd3;
		  3,4:s=3'd4;
		  5,6:s=3'd5;
		  7:s=3'd6;
	 endcase
    end
  3:
    begin
	 case({A[1:0], Cin})
		  0:s=3'd3;
		  1,2:s=3'd4;
		  3,4:s=3'd5;
		  5,6:s=3'd6;
		  7:s=3'd7;
	 endcase
    end
endcase
assign S[1:0] = s[1:0];
assign Cout = s[2];endmodule