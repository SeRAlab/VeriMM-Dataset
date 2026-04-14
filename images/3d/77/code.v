module mux32to1 (
    input [31:0] in, // 32 input lines
    input [4:0] sel, // 5 selection lines
    output out        // output line
);
    assign out = in[sel]; // output the selected input
endmodule