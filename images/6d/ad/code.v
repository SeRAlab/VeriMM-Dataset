module top_module(
 

    vout,                           
 

    din,                            
    sclk,                           
    sync_n                          
);output       [11:0] vout;           
 


input               din;            
input               sclk;           
input               sync_n;         
 






reg  sync_dly_n;
always @ (negedge sclk)
  sync_dly_n <= sync_n;

wire spi_tfx_start = ~sync_n & sync_dly_n;
   


reg [3:0] spi_cnt;
wire      spi_cnt_done = (spi_cnt==4'hf);
always @ (negedge sclk)
  if (sync_n)              spi_cnt <=  4'hf;
  else if (spi_tfx_start)  spi_cnt <=  4'he;
  else if (~spi_cnt_done)  spi_cnt <=  spi_cnt-1;

wire spi_tfx_done = sync_n & ~sync_dly_n & spi_cnt_done;

   

reg  [15:0] dac_shifter;
always @ (negedge sclk)
  dac_shifter <=  {dac_shifter[14:0], din};



reg  [11:0] vout;
always @ (negedge sclk)
  if (spi_tfx_done)
    vout <=  dac_shifter[11:0];


endmodule