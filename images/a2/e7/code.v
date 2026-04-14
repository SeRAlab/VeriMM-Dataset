module top_module(
    input wire A,
    input wire B,
    input wire CI,
    output wire SUM,
    output wire COUT
);// Instantiate a structural full adder
    wire sum1, c1, c2;
    
    // Logic for SUM and COUT
    assign sum1 = A ^ B;
    assign SUM = sum1 ^ CI;
    assign COUT = (A & B) | (sum1 & CI);

endmodule