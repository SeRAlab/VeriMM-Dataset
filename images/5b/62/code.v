module top_module(
				   clka    ,
				   
				   cena_i  ,
		           rena_i  ,
		           wena_i  ,
		           addra_i ,
		           dataa_o ,
		           dataa_i ,
				   
				   clkb    ,     
				   cenb_i  ,   
				   renb_i  ,   
				   wenb_i  ,   
				   addrb_i ,   
				   datab_o ,   
				   datab_i
							);parameter     		DATA_WIDTH	=	128	;
parameter	  		ADDR_WIDTH	=	4	;







input                     clka   ;  
input   		          cena_i ;  
input   		          rena_i ;  
input   		          wena_i ;  
input   [ADDR_WIDTH-1:0]  addra_i;  
input   [DATA_WIDTH-1:0]  dataa_i;  
output	[DATA_WIDTH-1:0]  dataa_o;  


input                     clkb   ;  
input   		          cenb_i ;  
input   		          renb_i ;  
input   		          wenb_i ;  
input   [ADDR_WIDTH-1:0]  addrb_i;  
input   [DATA_WIDTH-1:0]  datab_i;  
output	[DATA_WIDTH-1:0]  datab_o;  






reg    [DATA_WIDTH-1:0]   mem_array[(1<<ADDR_WIDTH)-1:0];






reg	   [DATA_WIDTH-1:0]  dataa_r;
reg	   [DATA_WIDTH-1:0]  datab_r;







always @(posedge clka) begin                
	if(!cena_i && !wena_i) 
		mem_array[addra_i] <= dataa_i;
end

always @(posedge clka) begin
	if (!cena_i && wena_i)
		dataa_r <= mem_array[addra_i];
	else
		dataa_r <= 'bx;
end

assign dataa_o = rena_i ? 'bz : dataa_r;


always @(posedge clkb) begin                
	if(!cenb_i && !wenb_i) 
		mem_array[addrb_i] <= datab_i;
end

always @(posedge clkb) begin   
	if (!cenb_i && wenb_i)
		datab_r <= mem_array[addrb_i];
	else
		datab_r <= 'bx;
end

assign datab_o = renb_i ? 'bz : datab_r;

endmodule