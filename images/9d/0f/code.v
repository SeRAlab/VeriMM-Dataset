module top_module(
   // Outputs
   output reg sio_ce,      // baud rate
   output reg sio_ce_x4,   // baud rate x 4
   // Inputs
   input clk,
   input arst_n
);// Parameter declarations for baud rates
   parameter br_38400_16MHz = 103; // 16e6 / (38400*4) = 104 = 103 + 1
   parameter br_31250_40MHz = 319; // 40e6 / (31250*4) = 320 = 319 + 1	
   parameter br_31250_60MHz = 479; // 60e6 / (31250*4) = 480 = 479 + 1
   parameter br_57600_40MHz = 173; // 40e6 / (57600*4) = 174 = 173 + 1	
   parameter br_57600_60MHz = 260; // 60e6 / (57600*4) = 261 = 260 + 1	

   // Counter and register declarations
   reg [8:0] brx4_cntr;
   reg [1:0] br_cntr;
   
   // Baud rate pre-scaler macro
   `define BRX4pre &{brx4_cntr[8],brx4_cntr[2]}   // 57600 baud rate 60MHz

   // Counter logic
   always @(posedge clk or negedge arst_n) begin
      if (~arst_n) begin
         brx4_cntr <= 0;
      end
      else if (`BRX4pre) begin
         brx4_cntr <= 0;
      end
      else begin
         brx4_cntr <= brx4_cntr + 1'b1;
      end
   end
   
   // Baud rate logic
   always @(posedge clk or negedge arst_n) begin
      if (~arst_n) begin
         sio_ce_x4 <= 1'b0;
         sio_ce <= 1'b0;
      end
      else begin
         sio_ce_x4 <= `BRX4pre;
         sio_ce <= (&br_cntr) & (`BRX4pre);
      end
   end
   
endmodule