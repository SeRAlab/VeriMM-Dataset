module top_module(
    X ,
    A0,
    A1,
    A2,
    A3,
    S0,
    S1
);// Module ports
    output X ;
    input  A0;
    input  A1;
    input  A2;
    input  A3;
    input  S0;
    input  S1;

    // Local signals
    wire mux_4to2_out;

    // 4-to-1 MUX implementation using behavioral coding
    assign mux_4to2_out = (S1 == 0 && S0 == 0) ? A0 :
                          (S1 == 0 && S0 == 1) ? A1 :
                          (S1 == 1 && S0 == 0) ? A2 :
                          (S1 == 1 && S0 == 1) ? A3 : 1'b0; // Default case for safety

    assign X = mux_4to2_out;

endmodule