module top_module(input regwrite_mem,input regwrite_wb,input [4:0]rd_wb,input [4:0]rd_mem,input [4:0]rt,input [4:0]rs,output reg [1:0]forwards,output reg [1:0]forwardt);always @(regwrite_mem or rd_mem or rs)
begin
if ((regwrite_mem==1)  && (rd_mem==rs) && (rd_mem != 0))
begin
forwards <=1;
end
else if(regwrite_wb && (rd_wb==rs) && (rd_wb!=0))
begin
forwards <=2;
end
else 
begin
forwards <=0;
end

if ((regwrite_mem==1)  && (rd_mem==rt) && (rd_mem!=0))
forwardt <=1;
else if(regwrite_wb && (rd_wb==rt) && (rd_wb!=0))
forwardt <=2;
else 
forwardt <=0;

end


endmodule