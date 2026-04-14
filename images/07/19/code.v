module mux32to1 (
    input [31:0] in,   // 32 input lines
    input [4:0] sel,   // 5 select lines
    output out         // 1 output line
);
    assign out = in[sel]; // Select the input based on select lines
endmodule