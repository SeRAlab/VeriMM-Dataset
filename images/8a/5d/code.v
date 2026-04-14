module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] a,    // 8-bit input a
    input [7:0] b,    // 8-bit input b
    input enable,     // Enable input for the XOR operation
    output reg [7:0] x // 8-bit output for the XOR operation
);// Internal wires and registers
    wire [7:0] p, g;
    reg [7:0] c;

    // Carry-lookahead adder architecture
    assign p = a ^ b;
    assign g = a & b;
    always @ (posedge clk) begin
        if (reset) begin
            c <= 8'b00000000;
            x <= 8'b00000000;
        end else begin
            if (enable) begin
                c <= g | (p & c);
                x <= p ^ c;
            end else begin
                x <= 8'b00000000;
            end
        end
    end

endmodule