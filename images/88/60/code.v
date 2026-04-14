module top_module(
    input clk,
    input reset,            // Asynchronous reset
    input [3:0] d1,         // 4-bit input for shift register 1
    input [3:0] d2,         // 4-bit input for shift register 2
    input enable,
    output [3:0] q,         // 4-bit output from shift registers
    output [3:0] xor_output // 4-bit output from XOR module
);reg [3:0] q1, q2;           // Internal registers for shift registers
wire [3:0] xor_output_wire; // Internal wire for XOR module output

// Shift register 1
always @(negedge clk) begin
    if (reset == 0) begin
        q1 <= 4'b0;
    end else if (enable) begin
        q1 <= {q1[2:0], d1[0]};
    end
end

// Shift register 2
always @(negedge clk) begin
    if (reset == 0) begin
        q2 <= 4'b0;
    end else if (enable) begin
        q2 <= {q2[2:0], d2[0]};
    end
end

// XOR module
assign xor_output_wire = q1 ^ q2;
assign q = q2; // Output from shift register 2

// Output assignment
assign xor_output = xor_output_wire;

endmodule