module top_module( i0, i1, cin, s, cout );input [4:0] i0;
    input [4:0] i1;
    input cin;
    output [4:0] s;
    output cout;
    wire [7:0] cig_s;
    reg  [7:0] cig_si;
    reg  [7:0] cig_di;
    wire [7:0] cig_co;
    wire [4:0] si;
    wire [1:0] ci;

    assign si = i0 ^ i1;

    always @ (si or i0) begin
        cig_si = 8'h0;
        cig_di = 8'h0;
        cig_si[4:0] = si;
        cig_di[4:0] = i0;
    end

    assign ci[0] = cin;

    // CARRY4 behavior replaced with a simple cascade adder for synthesis
    wire [4:0] co_internal;
    wire [4:0] sum;

    assign {co_internal, sum} = {1'b0, i0} + {1'b0, i1} + cin;
    assign cig_s[4:0] = sum;
    assign cout = co_internal[4];

    assign s = cig_s[4:0];

endmodule