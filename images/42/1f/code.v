module top_module(
  input   wire  clk,
  input   wire  reset_n, 
  output  reg   fifo_rdreq, 
  input   wire  fifo_empty,
  input   wire  [31:0]  fifo_data,
  output  wire  lrck,
  output  wire  bck,
  output  wire  data);reg   [5:0]   tx_cnt;
  reg   [31:0]  audio_buf_a, audio_buf_b;

  assign  bck = ~clk & reset_n;
  assign  lrck = ~tx_cnt[4] & reset_n;
  assign  data = (tx_cnt[5] == 0)? audio_buf_a[31] : audio_buf_b[31];  
  always @(posedge clk, negedge reset_n)
  begin
    if(!reset_n)
    begin
      audio_buf_a <= 0;
      audio_buf_b <= 0;
      tx_cnt <= 0;
      fifo_rdreq <= 0;
    end
    else if(tx_cnt[5] == 0)
    begin
      audio_buf_a <= {audio_buf_a[30:0], 1'b0};
      tx_cnt <= tx_cnt + 1;
      if(tx_cnt == 6'b010000 && fifo_empty == 0) fifo_rdreq <= 1;
      else if(tx_cnt == 6'b010001 && fifo_empty == 0) fifo_rdreq <= 0;
      else if(tx_cnt == 6'b010010) audio_buf_b <= fifo_data;
      else audio_buf_b <= audio_buf_b;
    end
    else if(tx_cnt[5] == 1)
    begin
      audio_buf_b <= {audio_buf_b[30:0], 1'b0};
      tx_cnt <= tx_cnt + 1;
      if(tx_cnt == 6'b110000 && fifo_empty == 0) fifo_rdreq <= 1;
      else if(tx_cnt == 6'b110001 && fifo_empty == 0) fifo_rdreq <= 0;
      else if(tx_cnt == 6'b110010) audio_buf_a <= fifo_data;
      else audio_buf_a <= audio_buf_a;
    end
    else
    begin
      tx_cnt <= tx_cnt + 1;
    end
  end
endmodule