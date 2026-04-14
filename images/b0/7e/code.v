module top_module(Q, Qbar, C, D, PREbar, CLRbar);input  [31:0] D;
  input  C, PREbar, CLRbar;
  output [31:0] Q, Qbar;

  wire [31:0] Q_next;
  assign Q_next = (PREbar) ? 32'hffffffff : ((CLRbar) ? 32'h0 : D);

  assign Q = (C) ? Q_next : Q;
  assign Qbar = (C) ? ~Q_next : Qbar;
endmodule