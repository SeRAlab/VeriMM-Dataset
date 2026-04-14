module phase_detector (
    input wire A,
    input wire B,
    output wire OUT
);
    assign OUT = ~(A ^ B); // OUT is high when A and B are the same
endmodule