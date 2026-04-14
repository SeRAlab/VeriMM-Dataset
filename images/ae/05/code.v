module top_module(clk, cen, we, addr, write_data, read_data,
		  ram_clk, ram_we_b, ram_address, ram_data, ram_cen_b);input clk;			
   input cen;			
   input we;			
   input [18:0] addr;		
   input [35:0] write_data;	
   output [35:0] read_data;	
   output 	 ram_clk;	
   output 	 ram_we_b;	
   output [18:0] ram_address;	
   inout [35:0]  ram_data;	
   output 	 ram_cen_b;	

   
   wire 	 ram_cen_b = ~cen;

   
   
   

   reg [1:0]   we_delay;

   always @(posedge clk)
     we_delay <= cen ? {we_delay[0],we} : we_delay;
   
   

   reg [35:0]  write_data_old1;
   reg [35:0]  write_data_old2;
   always @(posedge clk)
     if (cen)
       {write_data_old2, write_data_old1} <= {write_data_old1, write_data};

   

   assign      ram_we_b = ~we;
   assign      ram_clk = 1'b0;  
	                              
											

                                   
                                   
                                   
   assign      ram_address = addr;
   
   assign      ram_data = we_delay[1] ? write_data_old2 : {36{1'bZ}};
   assign      read_data = ram_data;

endmodule