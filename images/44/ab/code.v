module top_module(input [4:0] chin,output reg [4:0] chout);parameter num_ch=6; 
 reg [2:0] aux; 
 always @(*) begin 
  aux = chin[2:0] + 3'd1; 
  if( num_ch==6 ) begin 
  chout[2:0] = aux[1:0]==2'b11 ? aux+3'd1 : aux; 
  chout[4:3] = chin[2:0]==3'd6 ? chin[4:3]+2'd1 : chin[4:3]; 
  end else begin 
  chout[2:0] = aux[1:0]==2'b11 ? 3'd0 : aux; 
  chout[4:3] = chin[2:0]==3'd2 ? chin[4:3]+2'd1 : chin[4:3]; 
  end 
 end 
 endmodule