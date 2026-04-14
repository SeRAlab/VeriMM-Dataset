module mux8to1 (
    input wire [7:0] d,    // 8 input data lines
    input wire [2:0] s,    // 3 selection lines
    output wire y          // output line
);
    assign y = d[s];       // select the output based on the selection lines
endmodule