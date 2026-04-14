module top_module(
    inout [7:0] a,
    inout [7:0] b,
    input g,
    input dir);reg wAB;
reg wBA;

reg [7:0] abuf;
reg [7:0] bbuf;

assign a = abuf;
assign b = bbuf;
		
always @ (wAB, a)
begin
    if (wAB == 1'b1)
        bbuf <= a; 
    else 
        bbuf <= 8'hzz;
end

always @ (wBA, b)
begin
    if (wBA == 1'b1)
        abuf <= b;
    else
        abuf <= 8'hzz;
end

always @(g, dir)
begin
    if (g == 1'b0) begin
        if(dir == 1'b1) begin
            wAB <= 1'b1;
            wBA <= 1'b0;
        end else if(dir == 1'b0) begin
            wAB <= 1'b0;
            wBA <= 1'b1;
        end else begin
            wAB <= 1'b0;
            wBA <= 1'b0;
        end
    end else begin
        wAB <= 1'b0;
        wBA <= 1'b0;
    end
end
		
endmodule