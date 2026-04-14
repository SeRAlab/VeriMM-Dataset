module top_module(Q, G, D);output Q; 
input  G, D;

       reg Q;

always @ (G or D) begin

       if (G==1)     Q <= #1 D;

end

endmodule