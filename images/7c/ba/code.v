module top_module(
      clk ,
      Res ,
      Din ,
      EN ,

      eccByte

 );input     clk ;
 input     Res ;
 input [3:0]    Din ;
 input     EN ; 

 output reg [7:0]   eccByte;

wire rp1,rp2,rp3;
wire [7:0] ecc;
assign rp1= ((Din[3] ^ Din[2] ^ Din[0])==1'b1)?1:0;
assign rp2= ((Din[3] ^ Din[1] ^ Din[0])==1'b1)?1:0;
assign rp3= ((Din[2] ^ Din[1] ^ Din[0])==1'b1)?1:0;

assign ecc[7]=1'b0;
assign ecc[6]=rp1;
assign ecc[5]=rp2;
assign ecc[4]=Din[3];
assign ecc[3]=rp3;
assign ecc[2]=Din[2];
assign ecc[1]=Din[1];
assign ecc[0]=Din[0];


always@(posedge clk)
  if (Res) begin
      eccByte<=8'h00;
  end else if (EN) begin
      eccByte<=ecc;
    end
endmodule