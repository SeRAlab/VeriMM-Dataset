module top_module( rt, rs,en, eqz,gez,gtz,lez,ltz,ne, eq);input en;
input [31:0] rs;
input [31:0] rt;
output eq;
output ne;
output ltz;
output lez;
output gtz;
output gez;
output eqz;

assign eq=(en)&(rs==rt);
assign ne=(en)&~eq;
assign eqz=(en)&~(|rs);
assign ltz=(en)&rs[31];
assign lez=(en)&rs[31] | eqz;
assign gtz=(en)&(~rs[31]) & ~eqz;
assign gez=(en)&(~rs[31]);

endmodule