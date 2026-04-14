module top_module(
   // Outputs
   data_out,
   // Inputs
   addr, datamode, data_in
);//Inputs
   input [2:0] addr;
   input [1:0] datamode;
   input [63:0] data_in;

   //Outputs
   output [63:0] data_out;

   //wires
   wire [3:0] byte0_sel;
   wire [31:0] data_mux;
   wire [31:0] data_aligned;
   wire byte1_sel1;
   wire byte1_sel0;
   wire byte2_en;
   wire byte3_en;

   //Shift down high word
   assign data_mux[31:0] = addr[2] ? data_in[63:32] : data_in[31:0];

   //Byte0
   assign byte0_sel[3] = addr[1:0] == 2'b11;
   assign byte0_sel[2] = addr[1:0] == 2'b10;
   assign byte0_sel[1] = addr[1:0] == 2'b01;
   assign byte0_sel[0] = addr[1:0] == 2'b00;

   //Byte1
   assign byte1_sel1 = datamode[1:0] == 2'b01 & addr[1:0] == 2'b10;
   assign byte1_sel0 = (datamode[1:0] == 2'b01 & addr[1:0] == 2'b00) |
                       datamode[1:0] == 2'b10 |
                       datamode[1:0] == 2'b11;

   //Byte2
   assign byte2_en = datamode[1:0] == 2'b10 |
                     datamode[1:0] == 2'b11;

   //Byte3
   assign byte3_en = datamode[1:0] == 2'b10 |
                     datamode[1:0] == 2'b11;

   //B0: 32 NANDs,8 NORS
   assign data_aligned[7:0] = {(8){byte0_sel[3]}} & data_mux[31:24] |
                             {(8){byte0_sel[2]}} & data_mux[23:16] |
                             {(8){byte0_sel[1]}} & data_mux[15:8] |
                             {(8){byte0_sel[0]}} & data_mux[7:0];

   //B1:
   assign data_aligned[15:8] = {(8){byte1_sel1}} & data_mux[31:24] |
                              {(8){byte1_sel0}} & data_mux[15:8];

   //B2: 8 NANDS
   assign data_aligned[23:16] = {(8){byte2_en}} & data_mux[23:16];

   //B3:
   assign data_aligned[31:24] = {(8){byte3_en}} & data_mux[31:24];

   //lower 32 bits
   assign data_out[31:0] = data_aligned[31:0];

   //Upper 32 bits are pass through
   assign data_out[63:32] = data_in[63:32];

endmodule