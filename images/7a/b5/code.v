module top_module(
    input areset,
    input inclk0,
    output reg c0,
    output reg locked
);reg [31:0] counter;
reg [31:0] phase_accumulator;
reg [31:0] phase_increment;
reg [31:0] frequency_ratio;
reg [31:0] reference_period;
reg [31:0] output_period;

// Calculate frequency ratio
always @ (posedge inclk0 or posedge areset) begin
    if (areset) begin
        frequency_ratio <= 0;
    end else begin
        frequency_ratio <= (reference_period << 16) / output_period;
    end
end

// Calculate phase increment
always @ (posedge inclk0 or posedge areset) begin
    if (areset) begin
        phase_increment <= 0;
    end else begin
        phase_increment <= frequency_ratio;
    end
end

// Calculate output period
always @ (posedge inclk0 or posedge areset) begin
    if (areset) begin
        output_period <= 0;
    end else begin
        output_period <= reference_period * frequency_ratio >> 16;
    end
end

// Update phase accumulator
always @ (posedge c0 or posedge areset) begin
    if (areset) begin
        phase_accumulator <= 0;
    end else begin
        phase_accumulator <= phase_accumulator + phase_increment;
    end
end

// Generate output clock signal
always @ (posedge c0 or posedge areset) begin
    if (areset) begin
        c0 <= 0;
    end else begin
        if (phase_accumulator >= (1 << 31)) begin
            c0 <= ~c0;
            phase_accumulator <= phase_accumulator - (1 << 31);
        end
    end
end

// Update locked output
always @ (posedge c0 or posedge areset) begin
    if (areset) begin
        locked <= 0;
    end else begin
        locked <= (phase_accumulator == 0);
    end
end

// Update reference period
always @ (posedge inclk0 or posedge areset) begin
    if (areset) begin
        reference_period <= 0;
    end else begin
        reference_period <= counter;
        counter <= 0;
    end
end

// Increment counter
always @ (posedge inclk0 or posedge areset) begin
    if (areset) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

endmodule