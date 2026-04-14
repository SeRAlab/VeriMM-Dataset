module bit_counter (
    input [15:0] D,
    output reg [3:0] count
);

// Create a 4-bit parallel prefix adder
wire [3:0] P[0:3];
assign P[0] = D[0:3];
assign P[1] = P[0] + D[4:7];
assign P[2] = P[1] + D[8:11];
assign P[3] = P[2] + D[12:15];

// Output the count
assign count = P[3];

endmodule