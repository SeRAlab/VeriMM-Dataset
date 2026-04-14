module top_module(
   input [1:0] select_ms,
   input [3:0] L, /* -6 <= L,U <= 7 */
   input [3:0] U,
   input [3:0] Y, /* 0 <= Y,Z <= 13 */
   input [3:0] Z,
   output [3:0] Lp,
   output [3:0] Up,
   output [3:0] Yp,
   output [3:0] Zp
);wire [3:0] fy;
wire [3:0] fz;
wire [3:0] sb;
wire [3:0] sc;
wire [3:0] sd;
wire [3:0] d;
wire [3:0] sb_max_sc;
wire [3:0] ms_plus_6;

// Calculate fy = max(0, 5 - Y).
assign fy = (5 > Y) ? 5 - Y : 4'd0;

// Calculate fz = max(0, 5 - Z).
assign fz = (5 > Z) ? 5 - Z : 4'd0;

// Calculate sb = L + fy.
assign sb = L + fy;

// Calculate sc = U + fz.
assign sc = U + fz;

// Calculate ms_plus_6 = ms + 6, where ms is selected by select_ms.
assign ms_plus_6 = (select_ms == 2'b00) ? 4'd2 : ((select_ms == 2'b01) ? 4'd5 : 4'd7);

// Calculate sb_max_sc = max(sb, sc).
assign sb_max_sc = (sb > sc) ? sb : sc;

// Calculate sd = max(ms_plus_6, sb_max_sc).
assign sd = (ms_plus_6 > sb_max_sc) ? ms_plus_6 : sb_max_sc;

// Calculate d = sd - 6.
assign d = sd - 4'd6;

// Calculate Lp = d - U.
assign Lp = d - U;

// Calculate Up = d - L.
assign Up = d - L;

// Calculate Yp = sd - sb.
assign Yp = sd - sb;

// Calculate Zp = sd - sc.
assign Zp = sd - sc;

endmodule