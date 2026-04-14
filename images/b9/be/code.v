module top_module(
    input clk,
    output reg pulse
);parameter BAUD_RATE = 4800;
parameter CLOCK_FREQ = 50000000;

reg [15:0] counter = 0;
reg [15:0] compare_value = CLOCK_FREQ / BAUD_RATE;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == compare_value) begin
        pulse <= 1;
        counter <= 0;
    end else begin
        pulse <= 0;
    end
end

endmodule