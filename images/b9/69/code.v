module top_module(
    input shift_enable,
    input load,
    input clear,
    input sclk,
    input [39:0] blk_in,
    output [39:0] blk_out
    );reg [39:0] shift_acc_reg;
	
	always @(posedge sclk)
	begin
		if (clear)
			shift_acc_reg = 40'd0;
		if (load && shift_enable)
			shift_acc_reg = {blk_in[39], blk_in[39:1]};
		else if (load && !shift_enable)
			shift_acc_reg = blk_in;
		else
			shift_acc_reg = shift_acc_reg;
	end

	assign blk_out = shift_acc_reg;
			
endmodule