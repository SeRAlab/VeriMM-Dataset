module top_module( 
    input clk,
    input reset,          // Asynchronous reset for the register
    input [7:0] d,        // 8-bit input for the register
    input wire [3:0] vec, // 4-bit input for the other module
    output [7:0] q,       // 8-bit output from the register
    output wire [3:0] outv, // 4-bit output from the other module
    output wire [1:0] outv1, // 2-bit output containing the first and third bits of the 4-bit input vector
    output wire [1:0] outv2, // 2-bit output containing the second and fourth bits of the 4-bit input vector
    output wire o3,       // Output for the second bit of the second 2-bit output vector
    output wire o2,       // Output for the first bit of the second 2-bit output vector
    output wire o1,       // Output for the second bit of the first 2-bit output vector
    output wire o0        // Output for the first bit of the first 2-bit output vector
);reg [7:0] reg_q;

// Register module with asynchronous reset
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        reg_q <= 8'b0;
    end else begin
        reg_q <= d;
    end
end

// Other module that takes in a 4-bit binary input and outputs the same vector, along with two separate 2-bit vectors
assign outv = vec;
assign outv1 = vec[3:2];
assign outv2 = vec[1:0];
assign o3 = vec[0];
assign o2 = vec[1];
assign o1 = vec[2];
assign o0 = vec[3];

// Functional module that takes in the outputs of both modules and outputs the bitwise OR of the two 8-bit values
assign q = reg_q | {8{outv}};

endmodule