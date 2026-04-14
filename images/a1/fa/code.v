module top_module(input IncA,input Reset,input clock,output reg [2:0]AddrA);always @(posedge clock)
begin

if(Reset==1)
begin
AddrA<=3'b0;
end

else
begin
if(IncA==1)
begin
AddrA<=AddrA+3'b1;
end

end


end

endmodule