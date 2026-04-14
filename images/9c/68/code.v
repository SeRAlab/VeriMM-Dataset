module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input a,
    input b,
    output reg out,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] temp_data;
reg [99:0] shifted_data;
reg [99:0] rotated_data;
wire [99:0] xor_output;

// XOR gate implementation
assign xor_output = a ^ b;

// Left/Right rotator implementation
always @(posedge clk) begin
    if (load) begin
        temp_data <= data;
    end else if (ena[0]) begin
        shifted_data[0] <= temp_data[99];
        shifted_data[99:1] <= temp_data[98:0]; // Corrected order
        temp_data <= shifted_data;
    end else if (ena[1]) begin
        shifted_data[99] <= temp_data[0];
        shifted_data[98:0] <= temp_data[99:1]; // Corrected order
        temp_data <= shifted_data;
    end
end

// Final output implementation
always @(posedge clk) begin
    rotated_data <= temp_data;
    out <= xor_output[0] ^ rotated_data[0];
    q <= {xor_output[98:0], xor_output[99]} ^ rotated_data[98:0]; // Corrected order
end

endmodule