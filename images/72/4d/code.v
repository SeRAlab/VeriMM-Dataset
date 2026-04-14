module top_module(
   
   uart_busy,   
   uart_tx,     
   
   uart_wr_i,   
   uart_dat_i,  
   sys_clk_i,   
   sys_rst_i    
);input uart_wr_i;
  input [7:0] uart_dat_i;
  input sys_clk_i;
  input sys_rst_i;
  
  output uart_busy;
  output uart_tx;

  reg [3:0] bitcount;
  reg [8:0] shifter;
  reg uart_tx;

  wire uart_busy = |bitcount[3:1];
  wire sending = |bitcount;

  

  reg [28:0] d;
  wire [28:0] dInc = d[28] ? (115200) : (115200 - 100000000);
  wire [28:0] dNxt = d + dInc;
  wire ser_clk = ~d[28];
  always @(posedge sys_clk_i)
    if (sys_rst_i) begin
       d = 0;
    end else begin
      d = dNxt;
    end

  always @(posedge sys_clk_i)
  begin
    if (sys_rst_i) begin
      uart_tx <= 1;
      bitcount <= 0;
      shifter <= 0;
    end else begin
      
      if (uart_wr_i & ~uart_busy) begin
        shifter <= { uart_dat_i[7:0], 1'h0 };
        bitcount <= (1 + 8 + 2);
      end
      
      if (sending & ser_clk) begin
        { shifter, uart_tx } <= { 1'h1, shifter };
        bitcount <= bitcount - 1;
      end
    end
  end

endmodule