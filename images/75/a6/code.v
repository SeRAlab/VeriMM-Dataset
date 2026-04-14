module top_module(
  input selector,
  input incrementor,
  input reverse,
  input clr,
  input wire [15:0]cntr_def_0,
  input wire [15:0]cntr_def_1,
  input wire [15:0]cntr_def_2,
  input wire [15:0]cntr_def_3,
  input wire [15:0]cntr_def_4,
  input wire [15:0]cntr_def_5,
  input wire [15:0]cntr_def_6,
  input wire [15:0]cntr_def_7,
  output wire [15:0]cntr0,
  output wire [15:0]cntr1,
  output wire [15:0]cntr2,
  output wire [15:0]cntr3,
  output wire [15:0]cntr4,
  output wire [15:0]cntr5,
  output wire [15:0]cntr6,
  output wire [15:0]cntr7,
  output wire [15:0]cntr_sel,
  output reg [7:0]cntr_ind
);reg [2:0] cntr_cur;
reg [15:0] cntrs[7:0];
assign cntr0 = cntrs[0];
assign cntr1 = cntrs[1];
assign cntr2 = cntrs[2];
assign cntr3 = cntrs[3];
assign cntr4 = cntrs[4];
assign cntr5 = cntrs[5];
assign cntr6 = cntrs[6];
assign cntr7 = cntrs[7];

wire [15:0] cntrs_def_int[7:0];
assign cntrs_def_int[0] = cntr_def_0;
assign cntrs_def_int[1] = cntr_def_1;
assign cntrs_def_int[2] = cntr_def_2;
assign cntrs_def_int[3] = cntr_def_3;
assign cntrs_def_int[4] = cntr_def_4;
assign cntrs_def_int[5] = cntr_def_5;
assign cntrs_def_int[6] = cntr_def_6;
assign cntrs_def_int[7] = cntr_def_7;

assign cntr_sel = cntrs[cntr_cur];

wire s = selector | clr | incrementor;
always @(posedge s) begin
  if (clr == 1) begin
    
    cntrs[cntr_cur] <= cntrs_def_int[cntr_cur];
  end else if (selector == 1) begin
    if (reverse == 1)
      cntr_cur <= cntr_cur - 1;
    else
      cntr_cur <= cntr_cur + 1;
  end else begin
    if (reverse == 1)
      cntrs[cntr_cur] <= cntrs[cntr_cur] - 1;
    else
      cntrs[cntr_cur] <= cntrs[cntr_cur] + 1;
  end
end


always @(cntr_cur) begin
  case(cntr_cur)
    0: cntr_ind <= 8'H01;
    1: cntr_ind <= 8'H02;
    2: cntr_ind <= 8'H04;
    3: cntr_ind <= 8'H08;
    4: cntr_ind <= 8'H10;
    5: cntr_ind <= 8'H20;
    6: cntr_ind <= 8'H40;
    7: cntr_ind <= 8'H80;
  endcase
end

endmodule