module top_module(dataInB, addOut, subOut, sign);input [7:0] addOut;
input [7:0] subOut;
input sign;
output reg [7:0] dataInB;
always @ (addOut,subOut,sign)
begin
    if(sign)
    	
        dataInB = addOut;
    else
    	
        dataInB = subOut;
end  
endmodule