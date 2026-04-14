module mux32to1 (
    input wire [31:0] d,  // 32 data inputs
    input wire [4:0] s,   // 5 select lines
    output wire y         // output
);
    assign y = d[s];      // select the appropriate data input
endmodule