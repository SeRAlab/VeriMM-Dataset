module top_module(input a, output b);assign b = ~a;
(* keep *) reg c;
always @* c <= ~a;
endmodule