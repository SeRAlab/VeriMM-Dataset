module top_module(ptch_D_diff_sat, ptch_err_sat, ptch_err_I, rev, mtr_duty);input signed [9:0] ptch_err_sat, ptch_err_I; 
input signed [6:0] ptch_D_diff_sat;

localparam MIN_DUTY = 15'h03D4;



output rev;
output [11:0] mtr_duty; 



wire signed [10:0] ptch_D_term; 

wire signed [9:0] ptch_P_term; 

wire signed [8:0] ptch_I_term; 

wire signed [11:0] ptch_PID; 

wire signed [10:0] ptch_PID_abs; 



assign ptch_D_term = ptch_D_diff_sat * $signed(9); 

assign ptch_P_term = (ptch_err_sat>>>2) + (ptch_err_sat>>>1); 

assign ptch_I_term = ptch_err_I>>>1; 

assign ptch_PID = ptch_P_term + ptch_I_term + ptch_D_term; 

assign rev = ptch_PID[11]; 

assign ptch_PID_abs = rev ? (~ptch_PID[10:0] + 1) : ptch_PID[10:0]; 

assign mtr_duty = MIN_DUTY + ptch_PID_abs; 



endmodule