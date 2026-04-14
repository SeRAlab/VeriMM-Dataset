module top_module(
    input [4:0] rna,
    input [4:0] rnb,
    input [4:0] wn,
    input [31:0] datain,
    input clk,
    input wreg,
	 input reset,
    output [31:0] qa,
    output [31:0] qb
    );reg [31:0] register[1:31];
	 
	 assign qa = (rna == 0)? 0:register[rna];
	 assign qb = (rnb == 0)? 0:register[rnb];
	 integer i;
	 always @(posedge clk or negedge reset)
		if(reset == 0) begin
			for ( i = 1;i<32;i = i + 1)
				register[i] = 0;
		end
		else if((wn != 0) && (wreg == 1))
			register[wn] = datain;

endmodule