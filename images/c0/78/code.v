module CRC_16(BITVAL, Enable, CLK, RST, CRC);
 input        BITVAL;
   input Enable;
   input        CLK;                           
   input        RST;                             
   output reg [15:0] CRC;                               
   wire         inv;
   assign inv = BITVAL ^ CRC[15];                   
  always @(posedge CLK or posedge RST) begin
		if (RST) begin
			CRC = 0;   
        end
      else begin
        if (Enable==1) begin
         CRC[15] = CRC[14];
         CRC[14] = CRC[13];
         CRC[13] = CRC[12];
         CRC[12] = CRC[11] ^ inv;
         CRC[11] = CRC[10];
         CRC[10] = CRC[9];
         CRC[9] = CRC[8];
         CRC[8] = CRC[7];
         CRC[7] = CRC[6];
         CRC[6] = CRC[5];
         CRC[5] = CRC[4] ^ inv;
         CRC[4] = CRC[3];
         CRC[3] = CRC[2];
         CRC[2] = CRC[1];
         CRC[1] = CRC[0];
         CRC[0] = inv;
        end
         end
      end
endmodule