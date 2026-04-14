module mux8to1 (
    input wire [7:0] D,  // 8 data inputs
    input wire [2:0] S,  // 3 select inputs
    output wire Y        // output
);
    assign Y = D[S];     // Select the appropriate data input based on the select lines
endmodule