module top_module(
    input [31:0] D1,
    input [31:0] D2,
	 input [3:0] BOp,
    output reg More,
    output reg Zero,
    output reg Less
    );wire [31:0] A,B;
	 
	 assign A=D1;
	 assign B=(BOp==4'b0011|BOp==4'b0100|BOp==4'b0101|BOp==4'b0110|BOp==4'b0111)?32'b0:D2;

	 always@* begin
	 More<=0;
	 Zero<=0;
	 Less<=0;
	     if(A==B)
		      Zero<=1;
		  else if((A[31]==1'b0)&(B[31]==1'b1))
		      More<=1;
		  else if((B[31]==1'b0)&(A[31]==1'b1))
		      Less<=1;
		  else begin
		      if(A[30:0]>B[30:0])
				    More<=1;
				else
				    Less<=1;
		  end
	 end


endmodule