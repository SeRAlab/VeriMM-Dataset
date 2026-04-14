module top_module(
    input clk,
    input [3:0] data,
    output reg [9:0] TERC
);reg [1:0] a, b;
reg p1, p2;

initial begin
    TERC = 10'b0;
end

always @(posedge clk) begin
    // Divide the input data into two nibbles
    a = data[3:2];
    b = data[1:0];
    
    // Calculate the parity bits
    p1 = a[0] ^ a[1] ^ b[0];
    p2 = a[1] ^ b[0] ^ b[1];
    
    // Form the encoded output TERC
    TERC = {a, p1, b, p2};
end

endmodule