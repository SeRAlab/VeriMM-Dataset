module top_module(y0,y1,y2,Z0,Z1,Z2,w);input y0,y1,y2,w;
output Z0,Z1,Z2;

assign Z0 = (((~w)&y0)||((~y0)&w));
assign Z1 = (((~w)&y1)||(y1&(~y0))||(w&y0&(~y1)&(~y2)));
assign Z2 = (((~w)&y2)||(y2&(~y0))||(w&y1&y0));

endmodule