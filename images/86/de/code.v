module top_module(
    input clock,
    input reset,
    output led, led2, led3, led4, led5
    );reg [26:0] count; 
      

always@ (posedge clock or posedge reset)
 begin
  if (reset)
   count <= 0;  
  else
   count <= count + 1;  
  end

assign led = count[26];   
assign led2 = count[25];
assign led3 = count[24];
assign led4 = count[23];
assign led5 = count[22];
endmodule