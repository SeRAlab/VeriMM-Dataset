module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    output out
);wire a = in1 & in2;
wire b = in1 & in3;
wire c = in1 & in4;
wire d = in2 & in3;
wire e = in2 & in4;
wire f = in3 & in4;

wire ab = a | b;
wire ac = a | c;
wire ad = a | d;
wire ae = a | e;
wire af = a | f;
wire bd = b | d;
wire be = b | e;
wire bf = b | f;
wire cd = c | d;
wire ce = c | e;
wire cf = c | f;
wire de = d | e;
wire df = d | f;
wire ef = e | f;

wire abc = ab | c;
wire abd = ab | d;
wire abe = ab | e;
wire abf = ab | f;
wire acd = ac | d;
wire ace = ac | e;
wire acf = ac | f;
wire ade = ad | e;
wire adf = ad | f;
wire aef = ae | f;
wire bcd = bd | c;
wire bce = be | e;  // Fixed the previous incorrect reference from 'bc' to 'be'
wire bcf = bf | f;  // Fixed the previous incorrect reference from 'bc' to 'bf'
wire bde = bd | e;
wire bdf = bd | f;
wire bef = be | f;
wire cde = cd | e;
wire cdf = cd | f;
wire cef = ce | f;
wire def = de | f;

assign out = abc | abd | abe | abf | acd | ace | acf | ade | adf | aef | bcd | bce | bcf | bde | bdf | bef | cde | cdf | cef | def;

endmodule