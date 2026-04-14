module hazard_detection (
    input wire a,
    input wire b,
    output wire y
);
    wire a_n, b_n;
    wire temp1, temp2;

    // Inverted inputs for hazard detection
    not (a_n, a);
    not (b_n, b);

    // Primary output
    and (temp1, a, b);
    and (temp2, a_n, b_n);
    assign y = temp1 | temp2; // Correct output without hazard
endmodule