module top_module(
input wire [3:0] iMultiplicador,
input wire [7:0] iMultiplicando,
output reg [7:0] oResult );always @(*)
case(iMultiplicador)
	0:oResult=0;
	1:oResult=iMultiplicando;
   2:oResult=iMultiplicando<<1;
	3:oResult=(iMultiplicando<<1) +iMultiplicando;
	4:oResult=(iMultiplicando<<2);
	5:oResult=(iMultiplicando<<2)+iMultiplicando;
	6:oResult=(iMultiplicando<<2)+(iMultiplicando<<1);
	7:oResult=(iMultiplicando<<2)+(iMultiplicando<<1)+iMultiplicando;
	8:oResult=iMultiplicando<<3;
	9:oResult=(iMultiplicando<<3)+iMultiplicando;
	10:oResult=(iMultiplicando<<3)+(iMultiplicando<<1);
	11:oResult=(iMultiplicando<<3)+(iMultiplicando<<1)+iMultiplicando;
   12:oResult=(iMultiplicando<<3)+(iMultiplicando<<2);
	13:oResult=(iMultiplicando<<3)+(iMultiplicando<<2)+ iMultiplicando;
  14:oResult=(iMultiplicando<<3)+(iMultiplicando<<2)+ (iMultiplicando<<1);
  15:oResult=(iMultiplicando<<3)+(iMultiplicando<<2)+ (iMultiplicando<<1) + iMultiplicando;

endcase
endmodule