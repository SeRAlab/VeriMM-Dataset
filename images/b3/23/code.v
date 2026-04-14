module top_module(z_in, c_in,z_out,c_out);input z_in,c_in;
output z_out,c_out;
reg z,c;

   assign z_out=z;
   assign c_out=c;
 
always @(z_in or c_in ) begin : proc_
	z=z_in;
	c=c_in;
	
end

endmodule