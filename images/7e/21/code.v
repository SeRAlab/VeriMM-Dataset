module top_module(  input   CLK,
             
              //host interface
              input  [ 2:0] CHANNEL,
              output [11:0] CONV_RESULT,
              input         REQUEST,
              output        BUSY,
              
              //device interface
              output  CS,
              output  SCLK,
              output  SDO,
              input   SDI  );reg [ 4:0] tx_sreg = 0;
reg [15:0] rx_sreg = 0;
reg [11:0] saved_data = 0;
reg [4:0] bit_cnt = 0;

              
always @(negedge CLK)
  begin
  if(BUSY)
    begin
    if(bit_cnt < 16)  bit_cnt <= bit_cnt + 5'd1;
    else              
      begin
      saved_data <= rx_sreg[11:0];
      bit_cnt <= 0;
      end
      
    tx_sreg[4:1] <= tx_sreg[3:0];
    tx_sreg[0] <= 0;
      
    end
  else
    begin
    if(REQUEST)
      begin
      bit_cnt <= 1;
      tx_sreg <= {2'b0, CHANNEL};
      end
    end
  end              


always@(posedge CLK)
  begin
  if(BUSY)
    begin
    rx_sreg[0] <= SDI;
    rx_sreg[15:1] <= rx_sreg[14:0];
    end
  end

//-----------------------------------------------

assign BUSY = (bit_cnt != 5'd0);
assign CS   = ~BUSY;
assign SDO  = tx_sreg[4];
assign SCLK = BUSY & CLK;
assign CONV_RESULT = saved_data; 

endmodule