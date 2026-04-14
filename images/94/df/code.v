module top_module(clk, ctrl, din, sel, dout);input clk;
   input [4:0] ctrl;
   input [31:0] din;
   input [1:0] sel;
   output reg [31:0] dout;
   always @(posedge clk)
     case (ctrl)
       5'b00000:
         dout[31:0] <= din & ~{2{sel}};
       5'b00001:
         dout[31:0] <= din | ~{2{sel}};
       5'b00010:
         dout[31:0] <= din ^ ~{2{sel}};
       5'b00011:
         dout[31:0] <= ~din;
       5'b00100:
         dout[31:0] <= din & {2{sel}};
       5'b00101:
         dout[31:0] <= din | {2{sel}};
       5'b00110:
         dout[31:0] <= din ^ {2{sel}};
       5'b00111:
         dout[31:0] <= {din[31:30], 30'b0};
       5'b01000:
         dout[31:0] <= {2'b0, din[1:0], 28'b0};
       5'b01001:
         dout[31:0] <= din & {din[31:30], 30'b0};
       5'b01010:
         dout[31:0] <= din | {din[31:30], 30'b0};
       5'b01011:
         dout[31:0] <= din ^ {din[31:30], 30'b0};
       5'b01100:
         dout[31:0] <= din & {2'b0, din[1:0], 28'b0};
       5'b01101:
         dout[31:0] <= din | {2'b0, din[1:0], 28'b0};
       5'b01110:
         dout[31:0] <= din ^ {2'b0, din[1:0], 28'b0};
       5'b01111:
         dout[31:0] <= ~{din[31:30], 30'b0};
       5'b10000:
         dout[31:0] <= ~{2'b0, din[1:0], 28'b0};
       default:
         dout[31:0] <= 0;
     endcase
endmodule