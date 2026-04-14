module top_module(
                         clk,
                         rst,
                         raddr1,
                         raddr2,
                         rf_write,
                         waddr,
                         data,
                         
                         rd_data1,
                         rd_data2
                         );input          clk;
input          rst;
input   [4:0]  raddr1;
input   [4:0]  raddr2;
input          rf_write;
input   [4:0]  waddr;
input   [31:0] data;

output  [31:0] rd_data1;
output  [31:0] rd_data2;

reg  [31:0] regfile [31:0];

always @ (posedge clk) begin
		if (rst==1'b1) begin
			if((rf_write==1'b1) && (waddr!=32'h0000))
			 begin
				regfile[waddr] <= data;
			 end
		end
	end
	reg  [31:0]  rd_data1;
	reg  [31:0]  rd_data2;
	always @ (*) begin
		if(rst==1'b1) 
		  begin
			  rd_data1 <=32'h0000;
			end 
	  else if(raddr1==32'h0000) 
	     begin
	  		   rd_data1 <= 32'h0000;
	     end 
	  else if((raddr1== waddr) && (rf_write ==1'b1))
	     begin
	  	    rd_data1 <= data;
	     end 
	  else  
	     begin
	       rd_data1 <= regfile[raddr1];
       end
	end

	always @ (*) begin
		if(rst==1'b1) 
		  begin
			  rd_data2 <=32'h0000;
			end 
	  else if(raddr2==32'h0000) 
	     begin
	  		   rd_data2 <= 32'h0000;
	     end 
	  else if((raddr2== waddr) && (rf_write ==1'b1))
	     begin
	  	    rd_data2 <= data;
	     end 
	  else  
	     begin
	       rd_data2 <= regfile[raddr2];
       end
	end
endmodule