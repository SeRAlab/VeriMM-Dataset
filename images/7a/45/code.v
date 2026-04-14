module top_module( i0, i1, s );input [6:0] i0;
    input [6:0] i1;
    output [6:0] s;
    wire [7:0] cig_s;
    wire [7:0] cig_co;
    wire [6:0] si;
    wire [1:0] ci;
    
    assign si = i0 ^ i1;
    
    // Generate sum bits and carry bits
    assign {cig_co[0], cig_s[0]} = i0[0] + i1[0];
    assign {cig_co[1], cig_s[1]} = i0[1] + i1[1] + cig_co[0];
    assign {cig_co[2], cig_s[2]} = i0[2] + i1[2] + cig_co[1];
    assign {cig_co[3], cig_s[3]} = i0[3] + i1[3] + cig_co[2];
    assign {cig_co[4], cig_s[4]} = i0[4] + i1[4] + cig_co[3];
    assign {cig_co[5], cig_s[5]} = i0[5] + i1[5] + cig_co[4];
    assign {cig_co[6], cig_s[6]} = i0[6] + i1[6] + cig_co[5];
    assign cig_s[7] = cig_co[6]; // Carry-out (7th bit)
    
    assign s = cig_s[6:0];
endmodule