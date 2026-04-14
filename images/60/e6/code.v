module top_module(
    input [15:0] D,
    output reg [3:0] count
);// Create a 4-bit parallel prefix adder
wire [3:0] P[0:3];
assign P[0] = D[3:0];   // Corrected the part select order
assign P[1] = P[0] + D[7:4]; // Corrected the part select order
assign P[2] = P[1] + D[11:8]; // Corrected the part select order
assign P[3] = P[2] + D[15:12]; // Corrected the part select order

// Output the count
assign count = P[3];

endmodule