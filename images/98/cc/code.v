module top_module(
    input [3:0] datain,
    output reg [3:0] dataout
    );always @(datain)
      case(datain)
          4'h0 : dataout = 4'hC;
          4'h1 : dataout = 4'h5;
          4'h2 : dataout = 4'h6;
          4'h3 : dataout = 4'hB;
          4'h4 : dataout = 4'h9;
          4'h5 : dataout = 4'h0;
          4'h6 : dataout = 4'hA;
          4'h7 : dataout = 4'hD;
          4'h8 : dataout = 4'h3;
          4'h9 : dataout = 4'hE;
          4'hA : dataout = 4'hF;
          4'hB : dataout = 4'h8;
          4'hC : dataout = 4'h4;
          4'hD : dataout = 4'h7;
          4'hE : dataout = 4'h1;
          4'hF : dataout = 4'h2;
      endcase
endmodule