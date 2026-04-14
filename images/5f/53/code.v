module top_module(reset, crcinclk, crcbitin, crcoutclk, crcbitout, crcdone);input reset, crcinclk, crcbitin, crcoutclk; 
 output crcbitout, crcdone; 
 reg [15:0] crc; 
 reg [3:0] bitoutcounter; 
 wire crcdone; 
 assign crcbitout = crc[~bitoutcounter]; 
 assign crcdone = (bitoutcounter == 15); 
 always @ (posedge crcoutclk or posedge reset) begin 
  if (reset) begin 
  bitoutcounter <= 0; 
  end else if (!crcdone) begin 
  bitoutcounter <= bitoutcounter + 4'd1; 
  end 
 end 
 always @ (posedge crcinclk or posedge reset) begin 
  if (reset) begin 
  crc <= 'h0000; 
  end else begin 
  crc[0] <= ~(crcbitin ^ ~crc[15]); 
  crc[1] <= crc[0]; 
  crc[2] <= crc[1]; 
  crc[3] <= crc[2]; 
  crc[4] <= crc[3]; 
  crc[5] <= ~(~crc[4] ^ crcbitin ^ ~crc[15]); 
  crc[6] <= crc[5]; 
  crc[7] <= crc[6]; 
  crc[8] <= crc[7]; 
  crc[9] <= crc[8]; 
  crc[10] <= crc[9]; 
  crc[11] <= crc[10]; 
  crc[12] <= ~(~crc[11] ^ crcbitin ^ ~crc[15]); 
  crc[13] <= crc[12]; 
  crc[14] <= crc[13]; 
  crc[15] <= crc[14]; 
  end 
 end 
 endmodule