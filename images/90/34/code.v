module top_module(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    input clk, // Added the clk input
    output reg [15:0] S,
    output reg Cout
);reg [15:0] P, G, C1, C2;

always @ (posedge clk) begin
    P <= A ^ B;           // Update P on clk edge
    G <= A & B;           // Update G on clk edge
    C1 <= {1'b0, Cin};    // Current carry
    C2 <= {1'b1, Cout};   // Next carry
    S <= P ^ {Cout, C1[15:1]}; // Correct calculation for S
    Cout <= (G & C2) | (P & C1); // Adjusted carry generation
end

endmodule