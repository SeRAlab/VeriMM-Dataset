module mux32to1 (
    input [31:0] d,  // 32 data inputs
    input [4:0] s,   // 5 selection lines
    output y         // output
);
    assign y = d[s]; // Select the appropriate data input based on selection lines
endmodule