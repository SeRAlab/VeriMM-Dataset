module top_module(
    input [3:0] in,
    input [3:0] force_bits,
    input [3:0] force_values,
    input [3:0] release_bits,
    output reg [3:0] bus // Changed output to reg
);reg [3:0] bus_reg;
reg [3:0] force_reg;

// Initialize bus to 0000
initial begin
    bus_reg = 4'b0;
    force_reg = 4'b0;
    bus = 4'b0; // Initialize bus in the initial block
end

// Assign bus to input if not forced
always @(*) begin
    bus = (force_reg & bus_reg) | (~force_reg & in);
end

// Force bits
always @(*) begin
    if (force_bits != 4'b0) begin
        force_reg = force_bits;
        bus_reg = (force_values & force_bits) | (~force_bits & bus_reg);
    end
end

// Release bits
always @(*) begin
    if (release_bits != 4'b0) begin
        force_reg = ~release_bits & force_reg;
        bus_reg = (~release_bits & bus_reg) | (release_bits & in);
    end
end

endmodule