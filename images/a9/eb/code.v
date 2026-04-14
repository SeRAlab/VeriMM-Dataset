module top_module(
    input a,
    input b,
    input clk,
    input reset,      // Synchronous active-high reset
    output reg out_comb // Output from the functional module that combines the XOR gate and the counter
);// Internal wires and registers
reg [3:0] counter;  // Changed from wire to reg to allow assignments
wire even;
wire odd;
wire xor_out;
reg [3:0] next_counter;

// XOR gate implementation
assign xor_out = a ^ b;

// 4-bit binary counter implementation using state machine architecture
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 4'b0;
    end else begin
        case (counter)
            4'b0000: next_counter = 4'b0001;
            4'b0001: next_counter = 4'b0010;
            4'b0010: next_counter = 4'b0011;
            4'b0011: next_counter = 4'b0100;
            4'b0100: next_counter = 4'b0101;
            4'b0101: next_counter = 4'b0110;
            4'b0110: next_counter = 4'b0111;
            4'b0111: next_counter = 4'b1000;
            4'b1000: next_counter = 4'b1001;
            4'b1001: next_counter = 4'b1010;
            4'b1010: next_counter = 4'b1011;
            4'b1011: next_counter = 4'b1100;
            4'b1100: next_counter = 4'b1101;
            4'b1101: next_counter = 4'b1110;
            4'b1110: next_counter = 4'b1111;
            4'b1111: next_counter = 4'b0000;
            default: next_counter = 4'b0000; // Default case to avoid latch
        endcase
        counter <= next_counter;
    end
end

// Determine if the counter value is even or odd
assign even = ~counter[0];
assign odd = counter[0];

// Functional module implementation
always @ (*) begin
    if (even) begin
        out_comb = xor_out;
    end else if (odd) begin
        out_comb = counter;
    end
end

endmodule