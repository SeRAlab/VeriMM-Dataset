module top_module(
input [127:0] ip,
input [127:0] ip_key,
input enable,
output [127:0] op
);wire[127:0] temp; 
                        
 
 
  
   
    assign temp = ip ^ ip_key;
  
 
  
   assign op = enable? temp:ip;
endmodule