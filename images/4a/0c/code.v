module top_module(Hexs,Scan,point,LES,Hexo,p,LE,AN);input [31:0] Hexs;
 input [2:0] Scan;
 input [7:0] point;
 input [7:0] LES;
 output reg [3:0] Hexo;
 output reg p,LE;
 output reg [3:0] AN;
 always@* begin
  case(Scan)
      3'b000:begin Hexo<=Hexs[ 3: 0];     AN<=4'b1110;p<=point[0];LE<=LES[0];end
		3'b001:begin Hexo<=Hexs[ 7: 4];		AN<=4'b1101;p<=point[1];LE<=LES[1];end
		3'b010:begin Hexo<=Hexs[11: 8];		AN<=4'b1011;p<=point[2];LE<=LES[2];end
		3'b011:begin Hexo<=Hexs[15:12];		AN<=4'b0111;p<=point[3];LE<=LES[3];end
		3'b100:begin Hexo<=Hexs[19:16];		AN<=4'b1110;p<=point[4];LE<=LES[4];end
		3'b101:begin Hexo<=Hexs[23:20];		AN<=4'b1101;p<=point[5];LE<=LES[5];end
		3'b110:begin Hexo<=Hexs[27:24];		AN<=4'b1011;p<=point[6];LE<=LES[6];end
		3'b111:begin Hexo<=Hexs[31:28];		AN<=4'b0111;p<=point[7];LE<=LES[7];end
	endcase
	end
endmodule