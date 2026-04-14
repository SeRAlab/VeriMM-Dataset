module top_module(
   input 	     clk,
   input 	     rst,
   
   input [11:0]      adr,
   input 	     wr,
   input [15:0]      data,
   
   output reg [15:0] req = 0,
   input [15:0]      ack,
   output reg [15:0] val = 0
   );parameter P_TASK_ADR=12'hffe; 
   
   
   reg [15:0] 	     ack_prev=0;
   always @(posedge clk)
     if(rst) ack_prev <= 0;
     else ack_prev <= ack; 
   
   
   genvar 	     i;
   for(i=0; i<16; i=i+1)
     always @(posedge clk)
       if(rst)
	 begin
	    val[i] <= 0;
	    req[i] <= 0;
	 end
       else
	 begin
	    req[i] <= 0;
	    case(val[i])
	      0:
		begin
		   if((adr == P_TASK_ADR) && wr) 
		     begin 
			val[i] <= val[i] | data[i]; 
		     end
		end
	      1:
		begin
		   req[i] <= 1;
		   if(ack[i])
		     req[i] <= 0;
		   if(ack_prev[i] && !ack[i]) 
		     begin
			req[i] <= 0;
			val[i] <= 0; 
		     end
		end 
	    endcase
	 end 
endmodule