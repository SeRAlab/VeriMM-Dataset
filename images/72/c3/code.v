module top_module(a, b, select, out);input [7:0] a, b;
    input select;
  
    output [7:0] out;
    assign out[0] = (~select & a[0]) | (select & b[0]);
    assign out[1] = (~select & a[1]) | (select & b[1]);
    assign out[2] = (~select & a[2]) | (select & b[2]);
    assign out[3] = (~select & a[3]) | (select & b[3]);
    assign out[4] = (~select & a[4]) | (select & b[4]);
    assign out[5] = (~select & a[5]) | (select & b[5]);
    assign out[6] = (~select & a[6]) | (select & b[6]);
    assign out[7] = (~select & a[7]) | (select & b[7]);endmodule