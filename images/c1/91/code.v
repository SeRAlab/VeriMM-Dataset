module ddr_infrastructure
  (
   input        clk_int,
   input        rst_calib1,
   input  [4:0] delay_sel_val,
   output [4:0] delay_sel_val1_val,
   output [4:0] dbg_delay_sel, 
   output       dbg_rst_calib
   );
   reg [4:0] delay_sel_val1; 
   reg       rst_calib1_r1;
   reg       rst_calib1_r2;
   assign dbg_delay_sel      = delay_sel_val1;
   assign dbg_rst_calib      = rst_calib1_r2;
   assign delay_sel_val1_val = delay_sel_val1;
   always@(negedge clk_int) 
     rst_calib1_r1    <= rst_calib1;
   always@(posedge clk_int) 
     rst_calib1_r2    <= rst_calib1_r1;
   always@(posedge clk_int) begin
      if( rst_calib1_r2 == 1'b0 )
	delay_sel_val1    <= delay_sel_val;
      else
	delay_sel_val1      <= delay_sel_val1;
   end
endmodule