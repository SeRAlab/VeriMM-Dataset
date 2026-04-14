module top_module(/*AUTOARG*/
   // Outputs
   dout,
   // Inputs
   clk, web, enb, addr, din
   );parameter ADDR_WIDTH = 10;

   input clk;
   input [3:0]web;
   input [3:0]enb;
   input [9:0] addr;
   input [31:0] din;
   output [31:0] dout;
   reg [31:0]    RAM [(2<<ADDR_WIDTH)-1:0];
   reg [31:0]    dout;

   always @(posedge clk)
     begin
        if (enb[0])
          begin
             if (web[0])
               begin
                  RAM[addr][7:0] <= din[7:0];
                  dout[7:0] <= din[7:0];
               end
             else begin
                dout[7:0] <= RAM[addr][7:0];
             end
          end
     end // always @ (posedge clk)
   always @(posedge clk)
     begin
        if (enb[1])
          begin
             if (web[1])
               begin
                  RAM[addr][15:8] <= din[15:8];
                  dout[15:8] <= din[15:8];
               end
             else begin
                dout[15:8] <= RAM[addr][15:8];
             end
          end
     end // always @ (posedge clk)

   always @(posedge clk)
     begin
        if (enb[2])
          begin
             if (web[2])
               begin
                  RAM[addr][23:16] <= din[23:16];
                  dout[23:16] <= din[23:16];
               end
             else begin
                dout[23:16] <= RAM[addr][23:16];
             end
          end
     end

   always @(posedge clk)
     begin
        if (enb[3])
          begin
             if (web[3])
               begin
                  RAM[addr][31:24] <= din[31:24];
                  dout[31:24] <= din[31:24];
               end
             else begin
                dout[31:24] <= RAM[addr][31:24];
             end
          end
     end

endmodule