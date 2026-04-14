module mux8to1 (
    input [7:0] d,  // 8 data inputs
    input [2:0] s,  // 3 selection inputs
    output y        // output
);
    assign y = d[s]; // select the output based on selection inputs
endmodule