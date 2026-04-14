module twos_complement (
    input signed [3:0] binary,
    output signed [3:0] twos_comp
);

assign twos_comp = ~binary + 1;

endmodule