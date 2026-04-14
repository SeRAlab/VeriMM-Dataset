module top_module(
    areset,
    inclk0,
    c0,
    c1,
    locked
);input      areset;
input      inclk0;
output reg c0;  // Changed to output reg
output reg c1;  // Changed to output reg
output      locked;

reg [31:0] counter;
reg [31:0] phase_accumulator;
reg [31:0] phase_increment;
reg [31:0] frequency_ratio;
reg        locked_reg;

// Calculate the phase increment and frequency ratio
always @(*) begin
    frequency_ratio = 1000000000 / inclk0;
    phase_increment = frequency_ratio * (1 << 31) / 10000;
end

// Reset the PLL
always @(posedge areset) begin
    counter <= 0;
    phase_accumulator <= 0;
    locked_reg <= 0;
end

// Generate the output clocks and detect lock
always @(posedge inclk0) begin
    // Increment the phase accumulator
    phase_accumulator <= phase_accumulator + phase_increment;

    // Generate the output clock c0
    if (counter == 0) begin
        c0 <= 1;
        counter <= frequency_ratio / 2 - 1;
    end else begin
        c0 <= 0;
        counter <= counter - 1;
    end

    // Generate the output clock c1
    if (phase_accumulator[31] && !locked_reg) begin
        c1 <= 1;
        locked_reg <= 1;
    end else if (!phase_accumulator[31] && locked_reg) begin
        c1 <= 0;
        locked_reg <= 0;
    end
end

// Output the locked signal
assign locked = locked_reg;

endmodule