module ShiftRows
#
(
parameter DATA_W = 128       
)
(
input clk,                  
input reset,                
input valid_in,             
input [DATA_W-1:0] data_in,  
output reg valid_out,         
output reg [DATA_W-1:0] data_out 
)
;
wire [7:0] State [0:15];   
genvar i ;                                
generate 
for(i=0;i<=15;i=i+1) begin :STATE 
 assign State[i]= data_in[(((15-i)*8)+7):((15-i)*8)];  
end   
endgenerate  
always @(posedge clk or negedge reset)
if(!reset)begin
    valid_out <= 1'b0;
    data_out <= 'b0;
end else begin  
 if(valid_in)begin   
    data_out[(15*8)+7:(12*8)] <= {State[0],State[5],State[10],State[15]}; 
    data_out[(11*8)+7:(8*8)] <= {State[4],State[9],State[14],State[3]};                            
    data_out[(7*8)+7:(4*8)]  <= {State[8],State[13],State[2],State[7]};                         
    data_out[(3*8)+7:(0*8)]  <=  {State[12],State[1],State[6],State[11]}; 
 end 
    valid_out <= valid_in;                               
end
endmodule