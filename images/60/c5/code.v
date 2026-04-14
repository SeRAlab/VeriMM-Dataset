module top_module(input IN1, IN2, IN3, output QN, input VDD, VSS);wire a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z;

  assign a = IN1 | IN2;
  assign b = ~a;
  assign c = ~IN2;
  assign d = c | IN3;
  assign e = b & d;
  assign f = ~c;
  assign g = f & IN3;
  assign h = e | g;
  assign i = ~h;
  assign j = i & VDD;
  assign k = ~VSS;
  assign l = j & k;
  assign m = ~l;
  assign n = m & VDD;
  assign o = ~VSS;
  assign p = n & o;
  assign q = ~p;
  assign r = q & VDD;
  assign s = ~VSS;
  assign t = r & s;
  assign u = ~t;
  assign v = u & VDD;
  assign w = ~VSS;
  assign x = v & w;
  assign y = ~x;
  assign z = y & VDD;

  assign QN = z & ~VSS;

endmodule