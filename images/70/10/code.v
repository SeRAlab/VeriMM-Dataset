module top_module(
    input  a,
    input  b,
    input  [1:0] op,
    input  sel,
    input  vpwr,
    input  vgnd,
    output out
);wire and_out;
    wire or_out;
    wire xor_out;
    wire mux_out;
    wire mux_sel_inv;

    assign mux_sel_inv = ~sel;

    and and_gate (and_out, a, b);
    or or_gate (or_out, a, b);
    xor xor_gate (xor_out, a, b);
    
    // Fixing the undefined "mux" module issue by defining a simple mux implementation
    wire mux_a_out, mux_b_out;
    assign mux_a_out = (sel) ? b : a; // Basic 2-to-1 mux
    assign mux_out = mux_a_out; 

    bufif0 buf0 (out, and_out, (op == 2'b00));
    bufif0 buf1 (out, or_out, (op == 2'b01));
    bufif0 buf2 (out, xor_out, (op == 2'b10));
    bufif0 buf3 (out, mux_out, (op == 2'b11 && sel == 1'b1));
    bufif0 buf4 (out, mux_sel_inv, (op == 2'b11 && sel == 1'b0));

endmodule