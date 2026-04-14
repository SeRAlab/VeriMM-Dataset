module mux_8to1(
    input a,    // Input signal a.
    input b,    // Input signal b.
    input c,    // Input signal c.
    input d,    // Input signal d.
    input e,    // Input signal e.
    input f,    // Input signal f.
    input g,    // Input signal g.
    input h,    // Input signal h.
    input [2:0] sel,  // 3-bit Selection signal.
    output y    // Output signal.
);

assign y = (sel == 3'b000) ? a :
           (sel == 3'b001) ? b :
           (sel == 3'b010) ? c :
           (sel == 3'b011) ? d :
           (sel == 3'b100) ? e :
           (sel == 3'b101) ? f :
           (sel == 3'b110) ? g : h;  // Multiplexer operation.

endmodule