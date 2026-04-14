module top_module(input PI, CLK, reset, ld, cnt, Ci, output reg[3:0] PO, output Co);always @(posedge CLK or posedge reset) begin : proc_PO
		if(reset) begin
			PO <= 4'b0;
		end else begin
			if(ld)
				PO <= PI;
			else if(cnt)
				PO <= Ci ? (PO + 1) : PO;
		end
	end
	assign Co = (cnt) ? &{PO, Ci} : 1'b0;
endmodule