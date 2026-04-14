module top_module(
    input [7:0] in,  // 8-bit input for parity checker
    input [2:0] sel, // Select input for multiplexer
    input [3:0] data0, // 4-bit input for multiplexer
    input [3:0] data1, // 4-bit input for multiplexer
    input [3:0] data2, // 4-bit input for multiplexer
    input [3:0] data3, // 4-bit input for multiplexer
    input [3:0] data4, // 4-bit input for multiplexer
    input [3:0] data5, // 4-bit input for multiplexer
    output reg [3:0] out // 4-bit output from functional module
);reg [8:0] parity_in; // 9-bit input for parity checker
reg parity_out; // Parity bit output from parity checker

// Parity checker module
always @(*) begin
    parity_in = {in, 1'b0}; // Add a 0 to the end of the input for parity calculation
    parity_out = ^parity_in; // Calculate odd parity
end

// Multiplexer module
always @(*) begin
    case (sel)
        3'b000: out = data0;
        3'b001: out = data1;
        3'b010: out = data2;
        3'b011: out = data3;
        3'b100: out = data4;
        3'b101: out = data5;
        default: out = 4'b0000; // Default output if select input is invalid
    endcase
end

// Functional module
always @(*) begin
    out = {parity_out, out[3:0]} & 4'b1111; // Bitwise AND of parity bit and multiplexer output
end

endmodule