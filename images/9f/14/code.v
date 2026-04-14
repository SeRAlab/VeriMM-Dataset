module top_module(d1, d0, s, y);input d1, d0, s;
output y;
reg y;
always@(d1 or d0 or s)
begin
if (s) y = d1;
else y = d0;
end
endmodule