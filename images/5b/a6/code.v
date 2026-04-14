module top_module(
    EN,
    SEL,
    D0,
    D1,
    D2,
    D3,
    Y
);// Module ports
    input  EN ;
    input  [1:0] SEL;
    input  D0 ;
    input  D1 ;
    input  D2 ;
    input  D3 ;
    output Y  ;

    // Local signals
    wire [1:0] sel_inv;
    wire [3:0] mux_out;

    // Invert SEL signal
    assign sel_inv[0] = ~SEL[0];
    assign sel_inv[1] = ~SEL[1];

    // Mux implementation
    assign mux_out[0] = D0;
    assign mux_out[1] = D1;
    assign mux_out[2] = D2;
    assign mux_out[3] = D3;

    assign Y = (EN == 0) ? 1'b0 : mux_out[sel_inv];

endmodule