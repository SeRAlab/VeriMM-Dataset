module top_module(
   
   ff_out, fg_out, fh_out,
   
   clk, clken, rstn, in
   );input clk;
   input clken;
   input rstn;

   input [3:0] in;

   output reg [3:0] ff_out;
   reg [3:0] ff_10;
   reg [3:0] ff_11;
   reg [3:0] ff_12;
   reg [3:0] ff_13;
   always @(posedge clk) begin
      if ((rstn == 0)) begin
         ff_10 <= 0;
         ff_11 <= 0;
         ff_12 <= 0;
         ff_13 <= 0;
      end
      else begin
         ff_10 <= in;
         ff_11 <= ff_10;
         ff_12 <= ff_11;
         ff_13 <= ff_12;
         ff_out <= ff_13;
      end
   end

   output reg [3:0] fg_out;
   reg [3:0] fg_10;
   reg [3:0] fg_11;
   reg [3:0] fg_12;
   reg [3:0] fg_13;
   always @(posedge clk) begin
      if (clken) begin
         if ((rstn == 0)) begin
            fg_10 <= 0;
            fg_11 <= 0;
            fg_12 <= 0;
            fg_13 <= 0;
         end
         else begin
            fg_10 <= in;
            fg_11 <= fg_10;
            fg_12 <= fg_11;
            fg_13 <= fg_12;
            fg_out <= fg_13;
         end
      end
   end

   output reg [3:0] fh_out;
   reg [3:0] fh_10;
   reg [3:0] fh_11;
   reg [3:0] fh_12;
   reg [3:0] fh_13;
   always @(posedge clk) begin
      if ((rstn == 0)) begin
         fh_10 <= 0;
         fh_11 <= 0;
         fh_12 <= 0;
         fh_13 <= 0;
      end
      else begin
         if (clken) begin
            fh_10 <= in;
            fh_11 <= fh_10;
            fh_12 <= fh_11;
            fh_13[3:1] <= fh_12[3:1];
            fh_13[0] <= fh_12[0];
            fh_out <= fh_13;
         end
      end
   end


endmodule