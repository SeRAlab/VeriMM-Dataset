module rtc (
  input rst, clk,
  input        time_ld,
  input [37:0] time_reg_ns_in,   
  input [47:0] time_reg_sec_in,  
  input        period_ld,
  input [39:0] period_in,        
  input        adj_ld,
  input [31:0] adj_ld_data,
  output reg   adj_ld_done,
  input [39:0] period_adj,  
  output [37:0] time_reg_ns,  
  output [47:0] time_reg_sec, 
  output reg    time_one_pps,
  output [31:0] time_ptp_ns,  
  output [47:0] time_ptp_sec  
);
parameter time_acc_modulo = 38'd256000000000;  
reg  [39:0] period_fix;  
reg  [31:0] adj_cnt;
reg  [39:0] time_adj;    
always @(posedge rst or posedge clk) begin
  if (rst) begin
    period_fix  <= period_fix;  
    adj_cnt     <= 32'hffffffff;
    time_adj    <= time_adj;    
    adj_ld_done <= 1'b0;
  end
  else begin
    if (period_ld)  
      period_fix <= period_in;
    else
      period_fix <= period_fix;
    if (adj_ld)  
      adj_cnt  <= adj_ld_data;
    else if (adj_cnt==32'hffffffff)
      adj_cnt  <= adj_cnt;  
    else
      adj_cnt  <= adj_cnt - 1;  
    if (adj_cnt==0)  
      time_adj <= period_fix + period_adj;
    else
      time_adj <= period_fix + 0;
    if (adj_cnt==32'hffffffff)
      adj_ld_done <= 1'b1;
    else
      adj_ld_done <= 1'b0;
  end
end
reg  [39:0] time_adj_08n_32f;      
reg  [39:0] time_adj_16b_00n_24f;  
wire [37:0] time_adj_22b_08n_08f;  
always @(posedge rst or posedge clk) begin
  if (rst) begin
    time_adj_08n_32f     <= 40'd0;
    time_adj_16b_00n_24f <= 24'd0;
  end
  else begin
    time_adj_08n_32f     <= time_adj[39: 0] + time_adj_16b_00n_24f;  
    time_adj_16b_00n_24f <= {16'h0000, time_adj_08n_32f[23: 0]}; 
  end
end
assign time_adj_22b_08n_08f = time_adj_08n_32f[39]? {22'h3fffff, time_adj_08n_32f[39:24]}: {22'h000000, time_adj_08n_32f[39:24]};  
reg  [37:0] time_acc_30n_08f_pre_pos;  
reg  [37:0] time_acc_30n_08f_pre_neg;  
wire        time_acc_48s_inc = (time_acc_30n_08f_pre_pos >= time_acc_modulo)? 1'b1: 1'b0;
always @(posedge rst or posedge clk) begin
  if (rst) begin
    time_acc_30n_08f_pre_pos <= 38'd0;
    time_acc_30n_08f_pre_neg <= 38'd0;
  end
  else begin
    if (time_ld) begin  
      time_acc_30n_08f_pre_pos <= time_reg_ns_in + time_adj_22b_08n_08f;
      time_acc_30n_08f_pre_neg <= time_reg_ns_in + time_adj_22b_08n_08f;
    end
    else begin
      if (time_acc_48s_inc) begin
        time_acc_30n_08f_pre_pos <= time_acc_30n_08f_pre_neg + time_adj_22b_08n_08f;
        time_acc_30n_08f_pre_neg <= time_acc_30n_08f_pre_neg + time_adj_22b_08n_08f - time_acc_modulo;
      end
      else begin
        time_acc_30n_08f_pre_pos <= time_acc_30n_08f_pre_pos + time_adj_22b_08n_08f;
        time_acc_30n_08f_pre_neg <= time_acc_30n_08f_pre_pos + time_adj_22b_08n_08f - time_acc_modulo;
      end
    end
  end
end
reg  [37:0] time_acc_30n_08f;          
reg  [47:0] time_acc_48s;              
always @(posedge rst or posedge clk) begin
  if (rst) begin
    time_acc_30n_08f <= 38'd0;
    time_acc_48s     <= 48'd0;
  end
  else begin
    if (time_ld) begin  
      time_acc_30n_08f <= time_reg_ns_in;
      time_acc_48s     <= time_reg_sec_in;
    end
    else begin
      if (time_acc_48s_inc)
        time_acc_30n_08f <= time_acc_30n_08f_pre_neg;
      else
        time_acc_30n_08f <= time_acc_30n_08f_pre_pos;
      if (time_acc_48s_inc)
        time_acc_48s     <= time_acc_48s + 1;
      else
        time_acc_48s     <= time_acc_48s;
    end
  end
end
assign time_reg_ns  = time_acc_30n_08f;
assign time_reg_sec = time_acc_48s;
assign time_ptp_ns  = {2'b00, time_acc_30n_08f[37:8]};  
assign time_ptp_sec = time_acc_48s;
always @(posedge rst or posedge clk) begin
  if (rst)
    time_one_pps <= 1'b0;
  else
    time_one_pps <= time_acc_48s_inc;
end
endmodule