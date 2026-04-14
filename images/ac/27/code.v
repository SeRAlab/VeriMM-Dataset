module top_module(
    input wire clk_in,
    input wire pulse_in,
    input wire clk_out,
    output wire pulse_out
);reg [1:0] sync_pulse;
always @(posedge clk_in) begin
    if (!pulse_in)
        sync_pulse <= 2'b00; // Use 2'b00 instead of 0
    else if (!sync_pulse[1])
        sync_pulse <= 2'b11; // Use 2'b11 instead of {1, 1}
end

reg [1:0] sync_out;
always @(posedge clk_out) begin
    sync_out <= {sync_pulse[0], sync_out[0]};
end

assign pulse_out = sync_out[1] && !sync_out[0];

endmodule