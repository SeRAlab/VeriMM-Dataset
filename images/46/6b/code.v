module top_module(out,a,b,sel,sel2);input a,b,sel,sel2;
output out;
reg tmp;
always@(a or b or sel)
    begin
    if(sel==0) tmp=a; 
    else tmp=b;
    end
always@(sel2)
    begin
        tmp=a;
    end
assign out = tmp;endmodule