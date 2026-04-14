module phase_detector (
    input A,
    input B,
    output OUT
);
    assign OUT = (A == B) ? 1'b1 : 1'b0;
endmodule