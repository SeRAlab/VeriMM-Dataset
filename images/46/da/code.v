module top_module(clk, rst_l, wm_imiss, wm_other, wm_stbwait, mul_wait, div_wait,fp_wait, mul_busy_e, div_busy_e, fp_busy_e, ldmiss, coreid);input clk; 
  input rst_l; 
  input [3:0] wm_imiss; 
  input [3:0] wm_other; 
  input [3:0] wm_stbwait; 
  input [3:0] mul_wait; 
  input [3:0] div_wait; 
  input [3:0] fp_wait; 
  input [3:0] mul_busy_e; 
  input [3:0] div_busy_e; 
  input [3:0] fp_busy_e; 
  input [3:0] ldmiss; 
  input [2:0] coreid; 
  reg [39:0] old_val, new_val; 
  initial 
  begin 
  old_val = 0; 
  new_val = 0; 
  end 
  always @(negedge clk)begin 
  if (rst_l) 
  begin 
  new_val = {wm_imiss[3:0],wm_other[3:0],wm_stbwait[3:0],mul_wait[3:0],div_wait[3:0],fp_wait[3:0], 
  mul_busy_e[3:0],div_busy_e[3:0],fp_busy_e[3:0],ldmiss[3:0]}; 
  if (new_val != old_val) 
  begin 
 $display ("%d: C%1d: WM: %x%x%x%x%x%x%x%x%x%x", $time, coreid, wm_imiss, wm_other,wm_stbwait, mul_wait, div_wait, fp_wait, mul_busy_e, div_busy_e, fp_busy_e, ldmiss); 
  end 
  old_val = new_val; 
  end 
  end 
 endmodule