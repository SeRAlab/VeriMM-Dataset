module top_module(
    input        clk,
    input        txd_start,
    input        baud1tick,  
    input  [7:0] txd_data,
    output reg   txd,  
    output       txd_busy
  );parameter RegisterInputData = 1;  
  reg [3:0] state;
  wire  BaudTick  = txd_busy ? baud1tick : 1'b0;
  wire  txd_ready;

  reg [7:0] txd_dataReg;

  
  assign txd_ready = (state==0);
  assign txd_busy  = ~txd_ready;

  always @(posedge clk) if(txd_ready & txd_start) txd_dataReg <= txd_data;
  wire [7:0] txd_dataD = RegisterInputData ? txd_dataReg : txd_data;

  always @(posedge clk)
  case(state)
    4'b0000: if(txd_start) state <= 4'b0001;
    4'b0001: if(BaudTick) state <= 4'b0100;
    4'b0100: if(BaudTick) state <= 4'b1000;  
    4'b1000: if(BaudTick) state <= 4'b1001;  
    4'b1001: if(BaudTick) state <= 4'b1010;  
    4'b1010: if(BaudTick) state <= 4'b1011;  
    4'b1011: if(BaudTick) state <= 4'b1100;  
    4'b1100: if(BaudTick) state <= 4'b1101;  
    4'b1101: if(BaudTick) state <= 4'b1110;  
    4'b1110: if(BaudTick) state <= 4'b1111;  
    4'b1111: if(BaudTick) state <= 4'b0010;  
    4'b0010: if(BaudTick) state <= 4'b0011;  
    4'b0011: if(BaudTick) state <= 4'b0000;  
    default: if(BaudTick) state <= 4'b0000;
  endcase

  reg muxbit;      
  always @( * )
  case(state[2:0])
    3'd0: muxbit <= txd_dataD[0];
    3'd1: muxbit <= txd_dataD[1];
    3'd2: muxbit <= txd_dataD[2];
    3'd3: muxbit <= txd_dataD[3];
    3'd4: muxbit <= txd_dataD[4];
    3'd5: muxbit <= txd_dataD[5];
    3'd6: muxbit <= txd_dataD[6];
    3'd7: muxbit <= txd_dataD[7];
  endcase

  always @(posedge clk) txd <= (state<4) | (state[3] & muxbit);  

endmodule