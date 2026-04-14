module top_module(		 	   
        input clk,
        input rst,
        input is_nop,
        output reg [100:0] ins_no,
        output reg [100:0] clk_no);always @(posedge clk  )
        if (~rst )clk_no=0;
        else
            clk_no = 1+clk_no;

    always @(posedge clk )
        if (~rst )ins_no=0;
        else if (~is_nop)
            ins_no = 1+ins_no;endmodule