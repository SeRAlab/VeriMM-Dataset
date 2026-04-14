module top_module (
        input [3:0] n,
        input l,
        output reg N1,
        output reg N2);assign N1 = (n[0] & l) | (n[3] & l);
	assign N2 = (n[1] & l);

endmodule