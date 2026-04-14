module top_module(
  ref_clk,
  reset,
  square_signal,
  signal_freq);input           ref_clk;
  input           reset;
  input           square_signal;
  output  [31:0]  signal_freq;

  

  reg     [31:0]  signal_freq         = 'h0;
  reg     [31:0]  signal_freq_counter = 'h0;
  reg     [ 2:0]  square_signal_buf   = 'h0;

  wire            signal_freq_en;

  assign signal_freq_en = ~square_signal_buf[2] & square_signal_buf[1];

  

  always @(posedge ref_clk) begin
    square_signal_buf[0]    <= square_signal;
    square_signal_buf[2:1]  <= square_signal_buf[1:0];
  end

  always @(posedge ref_clk) begin
    if (reset == 1'b1) begin
      signal_freq <= 32'b0;
      signal_freq_counter <= 32'b0;
    end else begin
      if(signal_freq_en == 1'b1) begin
        signal_freq <= signal_freq_counter;
        signal_freq_counter <= 32'h0;
      end else begin
        signal_freq_counter <= signal_freq_counter + 32'h1;
      end
    end
  end

endmodule