module mux16to1(
    input wire [15:0] d, // 16 data inputs
    input wire [3:0] s,  // 4 select inputs
    output wire y        // output
);
    assign y = d[s]; // Select data based on select lines
endmodule