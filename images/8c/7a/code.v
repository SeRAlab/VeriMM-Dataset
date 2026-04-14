module top_module(
  input  wire         clk, reset_n, sdi, sck, ss_n,
  output wire  [7:0]  adrs, data,
  output wire         rx_valid
);reg   [15:0]  shift_reg;
  reg   [7:0]   rx_buf1, rx_buf2;
  reg   [3:0]   rx_cnt;
  reg   [2:0]   valid_sync;
  wire          rx_done;

  assign  rx_done = &rx_cnt;
  assign  adrs = rx_buf2[15:8];
  assign  data = rx_buf2[7:0];
  assign  rx_valid = valid_sync[2];

  always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin
      valid_sync <= 0;
      rx_buf2 <= 0;
    end else begin
      valid_sync <= {valid_sync[1:0], rx_done};
      if(valid_sync[1]) rx_buf2 <= rx_buf1;
      else rx_buf2 <= rx_buf2;
    end
  end

  always @(negedge sck, negedge reset_n) begin
    if(!reset_n) begin
      shift_reg <= 0;
      rx_buf1 <= 0;
      rx_cnt <= 0;
    end else if(!ss_n) begin
      shift_reg <= {shift_reg[14:0], sdi};
      rx_cnt <= rx_cnt + 1;
      if(rx_done) rx_buf1 <= shift_reg[7:0];
    end
  end

endmodule