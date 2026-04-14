module phase_detector (
    input A,
    input B,
    output Z
);
    assign Z = ~(A ^ B); // Output is high when A and B are the same
endmodule