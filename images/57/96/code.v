module top_module(
    A,
    B,
    C,
    X
);output [3:0] X;
    input  [3:0] A;
    input  [3:0] B;
    input  [3:0] C;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire [3:0] max_value;

    // Determine the maximum value among A, B, and C
    assign max_value = (A >= B) ? ((A >= C) ? A : C) : ((B >= C) ? B : C);

    // Determine if there are any ties
    wire is_tie_A_B = (A == B);
    wire is_tie_A_C = (A == C);
    wire is_tie_B_C = (B == C);

    // Determine the final output value based on the maximum value and any ties
    assign X = (max_value == A) ? (is_tie_A_B || is_tie_A_C) ? max_value : A :
              (max_value == B) ? (is_tie_A_B || is_tie_B_C) ? max_value : B :
                                 (is_tie_A_C || is_tie_B_C) ? max_value : C;

endmodule