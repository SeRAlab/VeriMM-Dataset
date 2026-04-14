module top_module(
    // Aurora Lane Interface
    input [1:0] SOFT_ERROR,
    input HARD_ERROR,
    input LANE_UP,

    // System Interface
    input USER_CLK,
    input POWER_DOWN,

    output reg CHANNEL_SOFT_ERROR,
    output reg CHANNEL_HARD_ERROR,
    output reg RESET_CHANNEL
);reg [1:0] soft_error_r;
reg hard_error_r;

wire channel_soft_error_c;
wire channel_hard_error_c;
wire reset_channel_c;

// Register all of the incoming error signals. This is necessary for timing.
always @(posedge USER_CLK) begin
    soft_error_r <= SOFT_ERROR;
    hard_error_r <= HARD_ERROR;
end

// Assert Channel soft error if any of the soft error signals are asserted.
assign channel_soft_error_c = soft_error_r[0] | soft_error_r[1];

always @(posedge USER_CLK) begin
    CHANNEL_SOFT_ERROR <= channel_soft_error_c;
end

// Assert Channel hard error if any of the hard error signals are asserted.
assign channel_hard_error_c = hard_error_r;

always @(posedge USER_CLK) begin
    CHANNEL_HARD_ERROR <= channel_hard_error_c;
end

// "reset_channel_r" is asserted when any of the LANE_UP signals are low.
assign reset_channel_c = !LANE_UP;

always @(posedge USER_CLK) begin
    RESET_CHANNEL <= reset_channel_c | POWER_DOWN;
end

endmodule