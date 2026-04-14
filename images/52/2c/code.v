module top_module(clk, t, ld_val, input_sel,
						mac0, mac1, mac2, mac3, mac4, mac5, mac6, mac7, mac8, mac9,
						store_values_out);input clk, t, ld_val;
		input[31:0] input_sel;
		
		input[7:0] mac0, mac1, mac2, mac3, mac4, mac5, mac6, mac7, mac8, mac9;
		
		output[7:0] store_values_out;

		reg [7:0] store_reg[0:19];
		
		always @(posedge clk) begin
			if(ld_val) begin
				store_reg[10 * t + 0] <= mac0;
				store_reg[10 * t + 1] <= mac1;
				store_reg[10 * t + 2] <= mac2;
				store_reg[10 * t + 3] <= mac3;
				store_reg[10 * t + 4] <= mac4;
				store_reg[10 * t + 5] <= mac5;
				store_reg[10 * t + 6] <= mac6;
				store_reg[10 * t + 7] <= mac7;
				store_reg[10 * t + 8] <= mac8;
				store_reg[10 * t + 9] <= mac9;
			end
		end
		
		assign store_values_out = store_reg[input_sel];
endmodule