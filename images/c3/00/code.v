module binary_adder(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
);

wire [4:0] temp; // Temporary signal to hold the sum

// Add the two input values, and store the result in the temporary signal
assign temp = {1'b0, A} + {1'b0, B};

// Assign the output signals
assign S = temp[3:0];
assign C_out = temp[4];

endmodule