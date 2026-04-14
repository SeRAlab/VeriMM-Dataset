module top_module(
               input wire         clk,                   // clock to trigger write
               input wire         rst,                   // reset
               input wire [4:0]   raddr1, raddr2, waddr, // the registers numbers to read or write
               input wire [31:0]  wdata,                 // data to write
               input wire         w_en,                  // write enable
               output wire [31:0] rdata1, rdata2         // the register values read
               );reg [31:0]                        rf [31:0];          // 32 registers each 32 bits long

   assign rdata1 = rf [raddr1];
   assign rdata2 = rf [raddr2];

   integer ii;
	
   initial
     begin
       for ( ii = 0; ii < 32; ii= ii + 1 )
          rf[ii] = 0;
     end
   
   always @(posedge clk)
     begin
        if (rst)
          rf[0] <= 0;
        else
          if(w_en)
            rf [waddr] <= wdata;
     end

endmodule