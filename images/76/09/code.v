module top_module(
    input       i_clk,	        
    input       i_clock_en, 	
    output      o_clk);assign o_clk = i_clk & i_clock_en;	

endmodule