module pit_prescale #(parameter COUNT_SIZE = 15,
                      parameter DECADE_CNTR = 1,
		      parameter NO_PRESCALE = 0)
  (
  output                      prescale_out,  
  output                      counter_sync,  
  input                       async_rst_b,   
  input                       sync_reset,    
  input                       bus_clk,       
  input                       cnt_sync_o,    
  input                       ext_sync_i,    
  input                       pit_slave,     
  input                 [3:0] divisor        
  );
reg    [COUNT_SIZE-1:0] cnt_n;         
reg    [COUNT_SIZE-1:0] end_count;     
wire                    div_1;         
wire                    rollover;      
   always @*
     if ( DECADE_CNTR )
       case (divisor)
          0: end_count = 1;
          1: end_count = 2;
          2: end_count = 4;
          3: end_count = 8;
          4: end_count = 10;
          5: end_count = 100;
          6: end_count = 1_000;
          7: end_count = 10_000;
          8: end_count = 20_000;
          default: end_count = 20_000;
        endcase
    else
        case (divisor)
           0: end_count = 1;
           1: end_count = 2;
           2: end_count = 4;
           3: end_count = 8;
           4: end_count = 16;
           5: end_count = 32;
           6: end_count = 64;
           7: end_count = 128;
           8: end_count = 256;
           9: end_count = 512;
          10: end_count = 1024;
          11: end_count = 2048;
          12: end_count = 4096;
          13: end_count = 8192;
          14: end_count = 16384;
          15: end_count = 32768;
        endcase
assign counter_sync = pit_slave ? ext_sync_i : cnt_sync_o;
assign div_1 = (end_count == 1);
assign rollover = NO_PRESCALE || (cnt_n == end_count);
assign prescale_out = (pit_slave && div_1 && ext_sync_i) || rollover; 
always @(posedge bus_clk or negedge async_rst_b)
  if ( !async_rst_b )
    cnt_n  <= 1;
  else if ( !counter_sync || rollover)
    cnt_n  <= 1;
  else
    cnt_n  <= cnt_n + 1;
endmodule