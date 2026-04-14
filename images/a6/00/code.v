module top_module(
      clk,
      Res,
      F_ecc_data ,
      WrECC,
      error_bv,
      ECC_status
);input    clk;
  input    Res;
  input  [6:0]  F_ecc_data ; 
  input    WrECC ;
  input    error_bv;

  output reg ECC_status;

wire check1,check2,check3;
reg [6:0] din;

always@(posedge clk)
 if (Res)
  din <= 8'h00;
 else if (WrECC)
  din <= F_ecc_data;

assign check1=din[6]^din[4]^din[2]^din[0];
assign check2=din[5]^din[4]^din[1]^din[0];
assign check3=din[3]^din[2]^din[1]^din[0];

always@(posedge clk)
 if (Res)
  ECC_status <= 1'h0;
 else
  ECC_status <= (check1 | check2 | check3 | error_bv);


endmodule