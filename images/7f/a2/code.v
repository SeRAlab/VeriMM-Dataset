module top_module(
		input wire					clk,
		input wire					res,
		input wire		[ 1 : 0]	prescaler,
		output wire					clk_out
    );reg 					clk_div;
	reg [ 2**16 - 1 : 0 ]	counter;
	reg [ 2**16 - 1 : 0 ]	counter2;
	
	assign clk_out = clk_div;
	
	always @(prescaler or clk or counter or counter2) begin
		case(prescaler)
			2'b00:	clk_div = clk;
			2'b01:	clk_div = counter[0];
			2'b10:	clk_div = counter[2**16 - 1];
			2'b11:	clk_div = counter2[2**8 - 1];
		endcase
	end

	always @(posedge clk) begin
		if(res) begin
			counter <= {(2**22 - 1){1'b0}};
			counter2 <= {(2**22 - 1){1'b0}};
		end
		else counter <= counter + 1'b1;
	end
	
	always @(counter[2**16 - 1])
		counter2 <= counter2 + 1'b1;
	

endmodule