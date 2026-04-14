module top_module(
    input clk,
    input rst_n,
    output [12:0] out
    );reg [12:0] random, random_next, random_done;
reg [3:0] count, count_next; 
wire feedback;

assign feedback = random[11] ^ random[10] ^ random[7] ^ random[3] ; 
 
always @ (posedge clk or posedge rst_n)
begin
 if (rst_n)
 begin
  random <= 13'hF; 
  count <= 0;
 end
  
 else
 begin
  random <= random_next;
  count <= count_next;
 end
end
 
always @ (*)
begin
 random_next = random; 
   
  random_next = {random[11:0], feedback}; 
  count_next = count + 1;
 
 if (count_next == 13)
 begin
  count_next = 0;
  random_done = random; 
 end

 else begin
 	count_next=count;
 	random_done=random;
 end


  
end
 
 
	assign out = random_done;endmodule