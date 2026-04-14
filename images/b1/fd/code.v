module top_module(
    x1,
    x2,
    cin,
    s,
    c
);input x1;
input x2;
input cin;
output s;
wire s;
output c;
wire c;

wire s_HA1HA2;
wire c_HA1CL;
wire c_HA2CL;




assign s_HA1HA2 = (x1 ^ x2);
assign c_HA1CL = (x1 & x2);



assign s = (cin ^ s_HA1HA2);
assign c_HA2CL = (cin & s_HA1HA2);



assign c = (c_HA1CL | c_HA2CL);

endmodule