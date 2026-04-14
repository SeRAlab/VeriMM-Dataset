module top_module(input wire MemRead,
					input wire [31:0]ninst,
					output reg [31:0]inst
    );always@*begin
	if(MemRead==1)begin
		inst[31:0]=ninst[31:0];
	end
end
endmodule