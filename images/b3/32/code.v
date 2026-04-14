module top_module( y, a, b );input [3:0] a;
input [3:0] b;
output [12:0] y;
wire  dpa_zero, dpa_one;
wire [5:0] const__1_24_;
wire [7:0] C0;
wire [6:0] const__2_33_;
wire [7:0] C1;
wire [12:0] y_1_;
assign dpa_zero= 1024'h0;
assign dpa_one= 1024'h1;
assign const__1_24_=- 1024'h18;
assign const__2_33_=- 1024'h21;







assign C0= ((const__1_24_[4:0]-(const__1_24_[5]<<5)));



assign C1= ((const__2_33_[5:0]-(const__2_33_[6]<<6)));



assign y_1_= ((C0[6:0]-(C0[7]<<7))*(a[2:0]-(a[3]<<3))+
    (C1[6:0]-(C1[7]<<7))*(b[2:0]-(b[3]<<3)));



assign y = y_1_[12:0];






endmodule