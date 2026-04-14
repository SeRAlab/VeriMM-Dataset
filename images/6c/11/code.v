module top_module(
   
   rd_fifo_empty, rd_addr, rd_gray_pointer,
   
   reset, rd_clk, rd_wr_gray_pointer, rd_read
   );parameter AW   = 2; 

   
   
   
   input           reset;
   input           rd_clk;
   
   input [AW:0]    rd_wr_gray_pointer;
   input           rd_read;
   
   
   
   
   output          rd_fifo_empty;
   output [AW-1:0] rd_addr;
   output [AW:0]   rd_gray_pointer;
   
   
   
   
   reg [AW:0]      rd_gray_pointer;
   reg [AW:0]      rd_binary_pointer;
   reg             rd_fifo_empty;

   
   
   
   wire 	   rd_fifo_empty_next;
   wire [AW:0]     rd_binary_next;
   wire [AW:0]     rd_gray_next;
   
   
   
   always @(posedge rd_clk or posedge reset)
     if(reset)
       begin
	  rd_binary_pointer[AW:0]     <= {(AW+1){1'b0}};
	  rd_gray_pointer[AW:0]       <= {(AW+1){1'b0}};
       end
     else if(rd_read)
       begin
	  rd_binary_pointer[AW:0]     <= rd_binary_next[AW:0];	  
	  rd_gray_pointer[AW:0]       <= rd_gray_next[AW:0];	  
       end

   
   assign rd_addr[AW-1:0]        = rd_binary_pointer[AW-1:0];

   
   assign rd_binary_next[AW:0]  = rd_binary_pointer[AW:0] + 
				  {{(AW){1'b0}},rd_read};

   
   assign rd_gray_next[AW:0] = {1'b0,rd_binary_next[AW:1]} ^ 
			       rd_binary_next[AW:0];


   
   assign rd_fifo_empty_next = (rd_gray_next[AW:0]==rd_wr_gray_pointer[AW:0]);

   always @ (posedge rd_clk or posedge reset)
     if(reset)
       rd_fifo_empty <= 1'b1;
     else 
       rd_fifo_empty <= rd_fifo_empty_next;
 
endmodule