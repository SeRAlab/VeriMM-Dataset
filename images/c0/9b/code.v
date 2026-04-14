module fifo(clock,write_enb,read_enb,data_in,data_out,empty,full,resetn);
parameter WIDTH = 8;
parameter DEPTH = 16;
parameter POINTER_SIZE = 5;
input clock;
input resetn;    
input write_enb;
input read_enb; 
input [WIDTH-1:0] data_in;  
output [WIDTH-1:0] data_out; 
output empty;    
output full;     
wire empty;    
wire full;     
reg [WIDTH-1:0] memory [0:DEPTH-1]; 
reg [POINTER_SIZE-1:0] write_ptr; 
reg [POINTER_SIZE-1:0] read_ptr; 
reg [WIDTH-1:0] data_out;
assign empty = ((write_ptr - read_ptr)== 5'b00000) ? 1'b1 : 1'b0;
assign full  = ((write_ptr - read_ptr) == 5'b10000) ? 1'b1 : 1'b0; 
always@(posedge clock) 
begin 
	if (resetn == 1'b0) 
   begin
   write_ptr <= 5'b00000;
   read_ptr  <= 5'b00000;
   data_out <= 8'b00000000;
   end 
  else 
   begin
   if ((write_enb == 1'b1) &&  (full == 1'b0)) 
    begin
    memory[write_ptr] <= data_in;
    write_ptr <= write_ptr + 1;
    end 
   end
   begin
   if ((read_enb == 1'b1) &&  (empty == 1'b0)) 
    begin
    data_out <= memory[read_ptr];
    read_ptr <= read_ptr + 1;
    end
   end 
end
endmodule