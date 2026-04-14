module top_module(input clk,input rst,input [7:0] uart_din,input uart_valid,output reg [7:0] uart_dout,output reg uart_wr,output [31:0] data_b,output strobe_b,input [31:0] addr_b,input [31:0] data_b_in,input [31:0] data_b_we);reg [7:0] uart_din_r; 
  reg uart_valid_r; 
  reg uart_ready_r; 
  reg uart_rd; 
  wire uart_busy; 
  wire uart_ready; 
  assign uart_ready = ~uart_busy; 
  assign uart_busy = 0; 
  assign strobe_b = (addr_b == 65537) | (addr_b == 65538) | (addr_b == 65539); 
  assign data_b = (addr_b == 65537)?uart_valid_r: 
  (addr_b == 65538)?uart_ready_r: 
  (addr_b == 65539)?uart_din_r:0; 
  always @(posedge clk) 
  if (~rst) begin 
  end else begin 
  if (uart_wr) begin 
  uart_wr <= 0; 
  end 
  if (uart_valid & ~uart_rd) begin 
  uart_rd <= 1; 
  end 
  uart_ready_r <= uart_ready; 
  if (uart_rd) begin 
  uart_rd <= 0; 
  uart_din_r <= uart_dout; 
  uart_valid_r <= 1; 
  end else if ((addr_b == 65539) & ~data_b_we & uart_valid_r) begin 
  uart_valid_r <= 0; 
  end else if ((addr_b == 65539) & data_b_we & uart_ready & ~uart_wr) begin 
  uart_dout <= data_b[7:0]; 
  uart_wr <= 1; 
  end 
  end 
 endmodule