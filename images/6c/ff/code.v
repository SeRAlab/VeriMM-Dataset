module top_module(
		input				clk,
		output		[31:0]	pc,
		input				branch,
		input		[31:0]	baddr);// branch address (relative)

	reg 	branch3 = 1'b0;
	reg	[31:0]	pc0 = 32'd0;
	reg	[31:0]	pc1 = 32'd0;
	reg	[31:0]	pc2 = 32'd0;
	reg	[31:0]	pc3 = 32'd0;

	assign pc = pc0;

	always @(posedge clk) begin

		if (branch3)
			pc0 <= pc3;		// stage 3 said to branch
		else
			pc0 <= pc0 + 4;	// normal increment

		// propagate pc through stage 1 and 2
		pc1 <= pc0;
		pc2 <= pc1;

		// default
		pc3		<= 32'd0;	// don't care
		branch3 <= 1'b0;  	// don't branch

		if (branch) begin
			pc3 <= pc2 + baddr;
			branch3 <= 1'b1;  // branch on the next stage
		end
	end

endmodule