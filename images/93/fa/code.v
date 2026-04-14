module top_module(a, b, c, y);input a;
  input b;
  input c;
  output y;

  supply1 vdd;
  supply0 gnd;
  wire net_35, net_7, net_8, net_9;

  and gate_0(net_8, a, b);
  and gate_1(net_9, net_8, c);
  not gate_2(net_35, net_8);
  not gate_3(net_7, net_9);
  nor gate_4(y, net_7, net_35);
  
endmodule