module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [3:0] G, // 4-bit Gray code input
    input [3:0] A, // 4-bit input for the multiplier
    input [3:0] B, // 4-bit input for the multiplier
    input select, // Select input to choose between Gray code input and multiplier output
    output reg [7:0] product // 8-bit output from the functional module
);// Gray code to binary converter
reg [3:0] binary;
always @ (G) begin
    binary[3] = G[3];
    binary[2] = binary[3] ^ G[2];
    binary[1] = binary[2] ^ G[1];
    binary[0] = binary[1] ^ G[0];
end

// 4-bit unsigned multiplier
reg [7:0] mult_out;
always @ (A, B) begin
    mult_out = {A, B} * select;
end

// Functional module
always @ (binary, mult_out) begin
    if (select == 0) begin
        product = {binary, 4'b0};
    end else begin
        product = mult_out;
    end
end

// Reset
always @ (posedge clk) begin
    if (reset) begin
        binary <= 4'b0;
        mult_out <= 8'b0;
        product <= 8'b0;
    end
end

endmodule