module top_module(out,data,load,reset,clk);parameter n=9;
output[n-1:0] out;
input[n-1:0] data;
input load,clk,reset;
reg[n-1:0] out;
always @(posedge clk or negedge reset)           
      begin
        if(!reset)  	out=0;    
        else  if(load) out=data;	  
        else	 	out=out+1;	  
     end
endmodule