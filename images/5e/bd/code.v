module top_module(CLK, rst_n,
                     ADDR_IN1, D_IN1, WE1,
                     ADDR_IN2, D_IN2, WE2,
                     ADDR_OUT1, ADDR_OUT2, ADDR_OUT3,
                     D_OUT1, D_OUT2, D_OUT3
                     );parameter data_width = 8;
   parameter addr_width = 4;
   parameter depth = 1<<addr_width;
   
   input CLK;
   input rst_n;
   
   input [addr_width - 1 : 0] ADDR_IN1;
   input [data_width - 1 : 0] D_IN1;
   input WE1;
   
   input [addr_width - 1 : 0] ADDR_IN2;
   input [data_width - 1 : 0] D_IN2;
   input WE2;
   
   input [addr_width - 1 : 0] ADDR_OUT1;
   input [addr_width - 1 : 0] ADDR_OUT2;
   input [addr_width - 1 : 0] ADDR_OUT3;
   
   output [data_width - 1 : 0] D_OUT1;
   output [data_width - 1 : 0] D_OUT2;
   output [data_width - 1 : 0] D_OUT3;
   
   reg [data_width - 1 : 0] arr [0 : depth-1];
   
   integer i;
   
   always @(posedge CLK) begin
      if (!rst_n) begin
         for (i = 0; i < depth; i = i + 1) begin
            arr[i] <= 0;
         end
      end else begin
         if (WE1) begin
            arr[ADDR_IN1] <= D_IN1;
         end
         if (WE2) begin
            arr[ADDR_IN2] <= D_IN2;
         end
      end
   end
   
   assign D_OUT1 = arr[ADDR_OUT1];
   assign D_OUT2 = arr[ADDR_OUT2];
   assign D_OUT3 = arr[ADDR_OUT3];

endmodule