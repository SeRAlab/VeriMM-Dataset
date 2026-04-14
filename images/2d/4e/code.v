module mux8to1 (
    input wire [7:0] d,    // 8 data inputs
    input wire [2:0] s,    // 3 selection inputs
    output wire y          // output
);
    assign y = d[s];       // Select the output based on the selection lines
endmodule