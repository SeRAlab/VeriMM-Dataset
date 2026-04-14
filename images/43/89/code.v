module top_module(clk,resetn,dataIn,dataOut,wr,rd,full,empty,overflow);parameter LOGSIZE = 2; 
  parameter WIDTH   = 32; 
  parameter SIZE = 1 << LOGSIZE;

  input clk,resetn,rd,wr;
  input [WIDTH-1:0] dataIn;
  output[WIDTH-1:0] dataOut;

  output full,empty,overflow;

  reg [WIDTH-1:0] fifo[SIZE-1:0] ; 
  reg overflow; 
  reg [LOGSIZE-1:0] wptr,rptr; 
  wire [WIDTH-1:0] fifoWire[SIZE-1:0] ; 

  reg counter = 0;
  reg [WIDTH-1:0] tempOut;

  wire [LOGSIZE-1:0] wptr_inc = wptr+1;
  assign empty = (wptr==rptr);
  assign full  = (wptr_inc==rptr);
  assign dataOut = tempOut;

  assign fifoWire[0] = fifo[0];

  
  
  
  
      
  
  
  
  
  

  always @ (posedge clk) begin
    if(wr==1) begin
      fifo[wptr]<=dataIn;
      wptr <= wptr + 1;
    end
    if(rd==1&&!empty) begin
      casex(counter)
        0: begin
		  tempOut <= fifo[rptr];
		  rptr <= rptr + 1;
		  counter <= 1;
		end
	  endcase
	end
	
	if(rd==0) begin
	  counter <=0;	        
    end  
    if(resetn==0) begin
      rptr<=0;
      wptr<=0;
    end    
  end  

endmodule