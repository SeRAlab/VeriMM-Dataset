module top_module(
  input   clk,        //bus clock
  input  [7:0] sample0,    //sample 0 input
  input  [7:0] sample1,    //sample 1 input
  input  [7:0] sample2,    //sample 2 input
  input  [7:0] sample3,    //sample 3 input
  input  [6:0] vol0,      //volume 0 input
  input  [6:0] vol1,      //volume 1 input
  input  [6:0] vol2,      //volume 2 input
  input  [6:0] vol3,      //volume 3 input
  output reg  [14:0]ldatasum,    //left DAC data
  output reg  [14:0]rdatasum    //right DAC data
);// volume control
reg [14-1:0] msample0, msample1, msample2, msample3;
always @ (*) begin
  if (vol0[6])
    msample0 = {16'h7FFF, sample0};
  else
    msample0 = {sample0, 8'h00} * vol0;
  if (vol1[6])
    msample1 = {16'h7FFF, sample1};
  else
    msample1 = {sample1, 8'h00} * vol1;
  if (vol2[6])
    msample2 = {16'h7FFF, sample2};
  else
    msample2 = {sample2, 8'h00} * vol2;
  if (vol3[6])
    msample3 = {16'h7FFF, sample3};
  else
    msample3 = {sample3, 8'h00} * vol3;
end

// channel muxing
// !!! this is 28MHz clock !!!
always @ (posedge clk) begin
  ldatasum <= #1 msample0[14:0] + msample1[14:0] + msample2[14:0] + msample3[14:0];
  rdatasum <= #1 msample0[14:0] + msample1[14:0] + msample2[14:0] + msample3[14:0];
end

endmodule