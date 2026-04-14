module mux2to1_behav (
    input a,
    input b,
    input sel,
    output out
);

    assign out = sel ? b : a;

endmodule