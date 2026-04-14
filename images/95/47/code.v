module top_module(clk,CSram,Direc,Datain,LeerMem,Dataout,EscrMem);input clk;
    input CSram;
    input [7:0] Direc;
    input [31:0] Datain;
    input LeerMem;
    output wire [31:0] Dataout;
    input EscrMem;
    
reg [31:0] RAM [0:255];

assign Dataout = LeerMem ? RAM[Direc]:32'b0;

always @ (posedge clk) 
begin

if(CSram==1'b1)
begin
    if (EscrMem==1'b1)
        begin
            RAM[Direc] = Datain;
        end  

end
end
endmodule