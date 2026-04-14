module wallace_tree_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);

wire [3:0] p0, p1, p2, p3;
wire [5:0] s0, s1, s2;
wire c0, c1;

assign p0 = A & {4{B[0]}};
assign p1 = A & {4{B[1]}};
assign p2 = A & {4{B[2]}};
assign p3 = A & {4{B[3]}};

assign s0 = p0 + {1'b0, p1[3:1]} + {2'b0, p1[0]};
assign s1 = p2 + {1'b0, p3[3:2]} + {2'b0, p3[1:0]};
assign s2 = {1'b0, s0[5:1]} + s1[5:1] + {2'b0, s1[0]};

assign P = {s2[5:1], s1[0], s0[0]};

endmodule