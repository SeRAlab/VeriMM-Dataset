module top_module(clk, a, b, z0, z1, z2, z3, z4, z5, z6);input               clk;

	input               a;
	input               b;
	output reg          z0;
    output              z1, z2, z3, z4, z5, z6;

    
    always @(posedge clk)
        z0 <= a;

    always @(posedge clk)
        z0 <= b;

    
    assign z1 = a;
    assign z1 = b;

    
    wire   comb2;
    assign comb2 = !z2 & a;
    assign z2 = comb2;

    
    wire   comb3;
    assign comb3 = !z3;
    assign z3 = comb3;

    
    wire   undriven;
    assign z4 = undriven | b;
    assign z5 = undriven & b;

    assign z6 = b;

endmodule