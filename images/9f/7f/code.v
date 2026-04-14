module top_module(
   input wire clk,

   input wire [2:0] rin,
   input wire [2:0] gin,
   input wire [1:0] bin,

   output reg [2:0] rout,
   output reg [2:0] gout,
   output reg [1:0] bout,

   output reg hs,
   output reg vs,

   output wire [10:0] hc,
   output wire [10:0] vc
   );/* http://www.abramovbenjamin.net/calc.html */

   // VGA 640x480@60Hz,25MHz
   parameter htotal = 800;
   parameter vtotal = 524;
   parameter hactive = 640;
   parameter vactive = 480;
   parameter hfrontporch = 16;
   parameter hsyncpulse = 96;
   parameter vfrontporch = 11;
   parameter vsyncpulse = 2;
   parameter hsyncpolarity = 0;
   parameter vsyncpolarity = 0;

   reg [10:0] hcont = 0;
   reg [10:0] vcont = 0;
   reg active_area;

   assign hc = hcont;
   assign vc = vcont;

   always @(posedge clk) begin
      if (hcont == htotal-1) begin
         hcont <= 0;
         if (vcont == vtotal-1) begin
            vcont <= 0;
         end
         else begin
            vcont <= vcont + 1;
         end
      end
      else begin
         hcont <= hcont + 1;
      end
   end

   always @* begin
      if (hcont >= 0 && hcont < hactive && vcont >= 0 && vcont < vactive)
         active_area = 1'b1;
      else
         active_area = 1'b0;

      hs = (hcont >= (hactive + hfrontporch) && hcont < (hactive + hfrontporch + hsyncpulse)) ? ~hsyncpolarity : hsyncpolarity;
      vs = (vcont >= (vactive + vfrontporch) && vcont < (vactive + vfrontporch + vsyncpulse)) ? ~vsyncpolarity : vsyncpolarity;
   end

   always @* begin
      if (active_area) begin
         gout = gin;
         rout = rin;
         bout = bin;
      end
      else begin
         gout = 3'b000; // Fixed hex to binary
         rout = 3'b000; // Fixed hex to binary
         bout = 2'b00;   // Fixed hex to binary
      end
   end
endmodule