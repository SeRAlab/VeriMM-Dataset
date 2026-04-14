module top_module(
    input [15:0] imm,
    input [1:0] EOp,
    output reg [31:0] ext
    );reg [15:0] a;
integer i;
always @(*)
begin
	case(EOp)
	2'b00:
	begin
		if(imm[15]==0)
		begin
			for(i=0;i<16;i=i+1)a[i]=0;
		end
		if(imm[15]==1)
		begin
			for(i=0;i<16;i=i+1)a[i]=1;
		end
		ext={a,imm};
	end
	2'b01:
	begin
		for(i=0;i<16;i=i+1)a[i]=0;
		ext={a,imm};
	end
	2'b10:
	begin
		for(i=0;i<16;i=i+1)a[i]=0;
		ext={imm,a};
	end
	2'b11:
	begin
		if(imm[15]==0)
		begin
			for(i=0;i<16;i=i+1)a[i]=0;
		end
		if(imm[15]==1)
		begin
			for(i=0;i<16;i=i+1)a[i]=1;
		end
		ext={a,imm};
		ext=ext<<2;
	end
	endcase
end

endmodule