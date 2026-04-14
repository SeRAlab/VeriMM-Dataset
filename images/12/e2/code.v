module mux8to1 (
    input wire [7:0] I,  // 8 input lines
    input wire [2:0] S,  // 3 select lines
    output wire Y        // output line
);
    assign Y = I[S];     // Select the output based on the select lines
endmodule