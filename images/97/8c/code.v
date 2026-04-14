module top_module(d1_enabled_write_endofpacket,fifo_datavalid,write_waitrequest,fifo_read,inc_write,mem_write_n,write_select);output fifo_read; 
  output inc_write; 
  output mem_write_n; 
  output write_select; 
  input d1_enabled_write_endofpacket; 
  input fifo_datavalid; 
  input write_waitrequest; 
  wire fifo_read; 
  wire inc_write; 
  wire mem_write_n; 
  wire write_select; 
  assign write_select = fifo_datavalid & ~d1_enabled_write_endofpacket; 
  assign mem_write_n = ~write_select; 
  assign fifo_read = write_select & ~write_waitrequest; 
  assign inc_write = fifo_read; 
 endmodule