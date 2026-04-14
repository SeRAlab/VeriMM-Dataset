module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output reg cout,
    output reg [3:0] sum
);// Internal wires for the carry chain
    wire [3:0] carry_chain;
    
    // Generate the initial carry chain
    assign carry_chain[0] = cin;
    assign carry_chain[1] = a[0] & b[0];
    assign carry_chain[2] = carry_chain[1] | (a[1] & b[1]);
    assign carry_chain[3] = carry_chain[2] | (a[2] & b[2]);
    
    // Calculate the sum and carry out
    always @(*) begin
        sum = a + b + cin;
        cout = carry_chain[3];
    end
    
endmodule