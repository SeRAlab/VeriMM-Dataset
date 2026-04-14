module top_module(
   input wire clk,
   input wire rst_n,
   input wire [15:0] a,
   input wire iorq_n,
   input wire rd_n,
   input wire wr_n,
   input wire [7:0] din,
   output reg [7:0] dout,
   output reg oe_n,
   output wire [7:0] addr,
   output wire read_from_reg,
   output wire write_to_reg,
   output wire regaddr_changed
   );parameter
      IOADDR = 16'hFC3B,
      IODATA = 16'hFD3B;


   reg [7:0] raddr = 8'h00;
   assign addr = raddr;
   reg rregaddr_changed = 1'b0;
   assign regaddr_changed = rregaddr_changed;
   
   always @(posedge clk) begin
      if (!rst_n) begin
         raddr <= 8'h00;
         rregaddr_changed <= 1'b1;
      end
      else if (!iorq_n && a==IOADDR && !wr_n) begin
         raddr <= din;
         rregaddr_changed <= 1'b1;
      end
      else
         rregaddr_changed <= 1'b0;
   end
    
   always @* begin
      if (!iorq_n && a==IOADDR && !rd_n) begin
         dout = raddr;
         oe_n = 1'b0;
      end
      else begin
         dout = 8'hZZ;
         oe_n = 1'b1;
      end
   end
   
   assign read_from_reg = (a==IODATA && !iorq_n && !rd_n);
   assign write_to_reg = (a==IODATA && !iorq_n && !wr_n);
   

endmodule