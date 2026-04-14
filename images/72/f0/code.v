module top_module(
    input wire [27:0] M1,
    input wire [27:0] M2,
    input wire [7:0]  r,
	 input wire        Greater,
    output reg [27:0] M1_norm,
    output reg [27:0] M2_norm,
    output reg [11:0] GRS_bits
    );reg [27:0] zero_padding;
always@(*)
	 begin
     zero_padding=28'b0;
	 	if(Greater==1)
	    begin
         M2_norm=M2;
		   M1_norm=M1;
         {M2_norm,zero_padding}={M2_norm,zero_padding} >>(r*4);
         GRS_bits=zero_padding[27:16];		
		 end
     else
       begin
         M1_norm=M1;
			M2_norm=M2;
         {M1_norm,zero_padding}={M1_norm,zero_padding} >>(r*4);
         GRS_bits=zero_padding[27:16];	
       end		
end
endmodule