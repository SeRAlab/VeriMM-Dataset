module top_module(
    areset,
    inclk0,
    c0,
    locked,
    brightness_control
);input areset;
input inclk0;
input [3:0] brightness_control;
output c0;
output locked;

reg [31:0] counter;
reg [31:0] duty_cycle;
reg locked;

parameter clk_divider = 25000000; // 50MHz / 2Hz
parameter lock_range = 100; // 200ppm / 2

wire clk_edge = inclk0 ^ ~inclk0;
wire locked_edge = locked ^ ~locked;

// Phase-locked loop
reg [31:0] phase_accumulator;
reg [31:0] phase_increment;
reg [31:0] error_accumulator;
reg [31:0] error_increment;

always @(posedge inclk0 or posedge areset) begin
    if (areset) begin
        phase_accumulator <= 0;
        error_accumulator <= 0;
    end else begin
        phase_accumulator <= phase_accumulator + phase_increment;
        error_accumulator <= error_accumulator + error_increment;
    end
end

assign c0 = phase_accumulator[31];
assign locked = (error_accumulator < lock_range) && (error_accumulator > -lock_range);

always @(posedge clk_edge or posedge areset) begin
    if (areset) begin
        phase_increment <= 0;
        error_increment <= 0;
    end else begin
        phase_increment <= clk_divider + error_accumulator;
        error_increment <= (brightness_control << 28) - error_accumulator / clk_divider;
    end
end

// Brightness control
always @(posedge c0 or posedge areset) begin
    if (areset) begin
        counter <= 0;
        duty_cycle <= 0;
    end else begin
        counter <= counter + 1;
        if (counter >= clk_divider) begin
            counter <= 0;
            duty_cycle <= brightness_control;
        end
    end
end

assign c0 = (counter < (clk_divider * duty_cycle / 16));

endmodule