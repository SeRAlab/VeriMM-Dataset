module top_module(din2_neq_din1_hi,din2_gt_din1_hi,din2_neq_din1_mid,din2_gt_din1_mid,din2_neq_din1_lo,din2_gt_din1_lo,din2_neq_din1,din2_gt_din1);input din2_neq_din1_hi; 
 input din2_gt_din1_hi; 
 input din2_neq_din1_mid; 
 input din2_gt_din1_mid; 
 input din2_neq_din1_lo; 
 input din2_gt_din1_lo; 
 output din2_neq_din1; 
 output din2_gt_din1; 
 wire din2_neq_din1; 
 wire din2_gt_din1; 
 assign din2_neq_din1= din2_neq_din1_hi || din2_neq_din1_mid || din2_neq_din1_lo; 
 assign din2_gt_din1= (din2_neq_din1_hi && din2_gt_din1_hi) 
 || ((!din2_neq_din1_hi) && din2_neq_din1_mid&& din2_gt_din1_mid) 
 || ((!din2_neq_din1_hi) && (!din2_neq_din1_mid)&& din2_gt_din1_lo); 
 endmodule