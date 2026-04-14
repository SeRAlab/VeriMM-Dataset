module top_module(
   
   data_out,
   
   addr, datamode, data_in
   );input [2:0] 	   addr;
   input [1:0] 	   datamode; 	   
   input [63:0]    data_in;

   
   output [63:0]   data_out;

   
   wire [3:0]      byte0_sel;
   wire [31:0]     data_mux;
   wire [31:0]     data_aligned;
   wire 	   byte1_sel1;
   wire 	   byte1_sel0;
   wire 	   byte2_en;
   wire 	   byte3_en;
   
   
   assign data_mux[31:0] = addr[2] ? data_in[63:32] : 
			             data_in[31:0];
      
   
   assign    byte0_sel[3] = addr[1:0]==2'b11;
   assign    byte0_sel[2] = addr[1:0]==2'b10;   
   assign    byte0_sel[1] = addr[1:0]==2'b01;
   assign    byte0_sel[0] = addr[1:0]==2'b00;
  
   
   assign    byte1_sel1 = datamode[1:0]==2'b01 & addr[1:0]==2'b10;

   assign    byte1_sel0 = (datamode[1:0]==2'b01 & addr[1:0]==2'b00) |
	                  datamode[1:0]==2'b10                      | 
			  datamode[1:0]==2'b11;
   
   assign    byte2_en = datamode[1:0]==2'b10 | 
		        datamode[1:0]==2'b11;
   
   assign    byte3_en = datamode[1:0]==2'b10 | 
		        datamode[1:0]==2'b11;
  
   
   assign data_aligned[7:0]   = {(8){byte0_sel[3]}} & data_mux[31:24] |
	                        {(8){byte0_sel[2]}} & data_mux[23:16] |
	                        {(8){byte0_sel[1]}} & data_mux[15:8]  |
	                        {(8){byte0_sel[0]}} & data_mux[7:0];
   
   assign data_aligned[15:8]  = {(8){byte1_sel1}} & data_mux[31:24] |
	                        {(8){byte1_sel0}} & data_mux[15:8];

   
   assign data_aligned[23:16] = {(8){byte2_en}} & data_mux[23:16];
   
   
   assign data_aligned[31:24] = {(8){byte3_en}} & data_mux[31:24];

   
   assign data_out[31:0]      = data_aligned[31:0];

   
   assign data_out[63:32]     = data_in[63:32];

endmodule