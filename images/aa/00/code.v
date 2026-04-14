module top_module(clk_i,
	      rst_i,
	      addr_i,
	      wdata_i,
	      w_r_data_i,
	      rdata_o,
	      valid_i,
	      ready_o);input clk_i,rst_i;
parameter WIDTH=16;
parameter DEPTH=64;
parameter ADDR_WIDTH=6; 

input [ADDR_WIDTH-1:0]addr_i;
input[WIDTH-1:0]wdata_i;
output reg [WIDTH-1:0] rdata_o;
input w_r_data_i;
input valid_i;
output reg ready_o;



reg[WIDTH-1:0]mem[DEPTH-1:0];
integer i;

always@(posedge clk_i)
 begin
	 if(rst_i==1)begin
	  ready_o=0;
	  rdata_o=0;
	  for(i=0;i<DEPTH;i=i+1)begin
	   mem[i]=0; 
	  end
	 end
	 else begin
	  if(valid_i==1)begin
	   ready_o=1;
	   
	    if(w_r_data_i==1)begin
	     mem[addr_i]=wdata_i; 
	    end
	    
	    else begin
	     rdata_o=mem[addr_i]; 
	    end
	  end
	  else begin
	  ready_o=0;
	  end

	 end
 end


endmodule