module top_module(clk, cen, we, addr, write_data, read_data,
             ram_clk, ram_we_b, ram_address, ram_data, ram_cen_b);input clk;            // system clock
   input cen;            // clock enable for gating ZBT cycles
   input we;             // write enable (active HIGH)
   input [18:0] addr;    // memory address
   input [35:0] write_data;   // data to write
   output [35:0] read_data;   // data read from memory
   output ram_clk;       // physical line to ram clock
   output ram_we_b;      // physical line to ram we_b
   output [18:0] ram_address; // physical line to ram address
   inout [35:0] ram_data; // physical line to ram data
   output ram_cen_b;     // physical line to ram clock enable

   wire ram_cen_b = ~cen;

   reg [1:0] we_delay;
   always @(posedge clk) begin
     if (cen) begin
       we_delay <= {we_delay[0], we};
     end
   end

   reg [35:0] write_data_old1;
   reg [35:0] write_data_old2;
   always @(posedge clk) begin
     if (cen) begin
       write_data_old2 <= write_data_old1;
       write_data_old1 <= write_data;
     end
   end

   assign ram_we_b = ~we;
   assign ram_clk = 1'b0;
   assign ram_address = addr;
   assign ram_data = we_delay[1] ? write_data_old2 : {36{1'bZ}};
   assign read_data = ram_data;

endmodule