module ddr_cal_ctl
  (
   input            clk,
   input            reset,
   input [31:0]     flop2,
   output reg [4:0] tapfordqs,
   output [4:0]     dbg_phase_cnt,
   output [5:0]     dbg_cnt,
   output           dbg_trans_onedtct,
   output           dbg_trans_twodtct,
   output           dbg_enb_trans_two_dtct
   );
   localparam tap1        = 5'b01111;
   localparam tap2        = 5'b10111;
   localparam tap3        = 5'b11011;
   localparam tap4        = 5'b11101;
   localparam tap5        = 5'b11110;
   localparam tap6        = 5'b11111;
   localparam default_tap = 5'b11101;
   reg [5:0]  cnt; 
   reg [5:0]  cnt1;
   reg [4:0]  phase_cnt;
   reg [31:0] tap_dly_reg;
   reg [4:0]  tapfordqs1;
   reg	      reset_r;
   reg        trans_onedtct;
   reg        trans_twodtct;
   reg        enb_trans_two_dtct;
   assign dbg_phase_cnt          = phase_cnt;
   assign dbg_cnt                = cnt1;
   assign dbg_trans_onedtct      = trans_onedtct;
   assign dbg_trans_twodtct      = trans_twodtct;
   assign dbg_enb_trans_two_dtct = enb_trans_two_dtct;
   always @( posedge clk )
     reset_r <= reset;
   always @(posedge clk) begin
      if(reset_r)
        enb_trans_two_dtct <= 1'b0;
      else if(phase_cnt >= 5'd1)
        enb_trans_two_dtct <= 1'b1;
      else
        enb_trans_two_dtct <= 1'b0;
   end
   always @(posedge clk) begin
      if(reset_r)
        tap_dly_reg <= 32'd0;
      else if(cnt[5] == 1'b1)
        tap_dly_reg <= flop2;
      else
        tap_dly_reg <= tap_dly_reg;
   end
   always @(posedge clk) begin
      if(reset_r || (cnt[5] == 1'b1))
        cnt[5:0] <= 6'b0;
      else
        cnt[5:0] <= cnt[5:0] + 1'b1;
   end
   always @(posedge clk) begin
      if(reset_r || (cnt1[5] == 1'b1))
        cnt1[5:0] <= 6'b0;
      else
        cnt1[5:0] <= cnt1[5:0] + 1'b1;
   end
   always @(posedge clk) begin
      if(reset_r || (cnt[5] == 1'b1)) 
        phase_cnt <= 5'd0;
      else if (trans_onedtct && (!trans_twodtct))
        phase_cnt <= phase_cnt + 1;
      else
        phase_cnt <= phase_cnt;
   end
   always @(posedge clk) begin
      if(reset_r || (cnt[5] == 1'b1)) begin
         trans_onedtct <= 1'b0;
         trans_twodtct <= 1'b0;
      end
      else if (cnt[4:0] == 5'd0 && tap_dly_reg[0]) begin
         trans_onedtct <= 1'b1;
         trans_twodtct <= 1'b0;
      end
      else if ((tap_dly_reg[cnt[4:0]]) && (trans_twodtct == 1'b0)) begin
         if((trans_onedtct == 1'b1) && (enb_trans_two_dtct) ) 
           trans_twodtct <= 1'b1;
         else
           trans_onedtct <= 1'b1;
      end
   end
   always @(posedge clk) begin
      if(reset_r)
         tapfordqs1 <= default_tap;
      else if(cnt1[4] && cnt1[3] &&
              cnt1[2] && cnt1[1] && cnt1[0]) begin
           if((trans_onedtct == 1'b0) || (trans_twodtct == 1'b0)
               || (phase_cnt > 5'd12))
              tapfordqs1 <= tap6;
           else if((phase_cnt > 5'd9))
              tapfordqs1 <= tap4;
           else if((phase_cnt > 5'd7))
              tapfordqs1 <= tap3;
           else if((phase_cnt > 5'd4))
              tapfordqs1 <= tap2;
           else
              tapfordqs1 <= tap1;
        end
      else
         tapfordqs1 <= tapfordqs1;
   end
  always @(posedge clk)
    tapfordqs  <= default_tap;
endmodule