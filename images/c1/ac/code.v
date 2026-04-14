module AddRoundKey
#
(
parameter DATA_W = 128            
)
(
input clk,                        
input reset,                      
input data_valid_in,              
input key_valid_in,               
input [DATA_W-1:0] data_in,       
input [DATA_W-1:0] round_key,     
output reg valid_out,             
output reg [DATA_W-1:0] data_out  
)
;
always@(posedge clk or negedge reset)
if(!reset)begin
    data_out <= 'b0;
    valid_out <= 1'b0;
end
else begin
    if(data_valid_in && key_valid_in) begin
    data_out <=  data_in ^ round_key;      
    end   
    valid_out <=  data_valid_in & key_valid_in;
end
endmodule