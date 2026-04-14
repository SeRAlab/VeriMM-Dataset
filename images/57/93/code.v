module top_module(
  input   wire  clk,
  input   wire  reset_n, 
  output  reg   fifo_rdreq, 
  input   wire  fifo_empty,
  input   wire  [31:0]  fifo_data,
  output  wire  pwm_out_l,
  output  wire  pwm_out_r);reg          data_rdy;
  reg  [11:0]  pwm_timer;
  reg  [31:0]  audiodata_32, audiodata_32_p;
  
  always @(posedge clk, negedge reset_n)
  begin
    if(!reset_n)
	  begin
		  pwm_timer <= 0;
      fifo_rdreq <= 0;
      audiodata_32 <= 0;
      audiodata_32_p <= 0;
      data_rdy <= 0;
    end
    else
    begin
      pwm_timer <= pwm_timer + 1'b1;
      if(pwm_timer == 12'h800 && fifo_empty == 0)
      begin
        fifo_rdreq <= 1'b1;
      end
      if(pwm_timer == 12'h801 && fifo_rdreq == 1)
      begin
        fifo_rdreq <= 0;
        audiodata_32_p <= fifo_data;
        data_rdy <= 1'b1;
      end
      if(pwm_timer == 12'hfff && data_rdy == 1)
      begin
        audiodata_32 <= audiodata_32_p;
        data_rdy <= 0;
      end
    end
  end
  
assign pwm_out_l = (pwm_timer <= audiodata_32[15:4]) ? 1'b1 :
                   (pwm_timer > audiodata_32[15:4])  ? 1'b0 : 1'bx;
  
assign pwm_out_r = (pwm_timer <= audiodata_32[31:20]) ? 1'b1 :
                   (pwm_timer > audiodata_32[31:20])  ? 1'b0 : 1'bx;

endmodule