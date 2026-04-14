module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [3:0] mux_in1, mux_in2, // 4-bit inputs for the multiplexer
    input select, // Select input to choose between mux_in1 and mux_in2
    output pwm // PWM output signal
);reg [3:0] counter;
reg [3:0] threshold;
wire dac_out;
wire pwm_out;

assign dac_out = select ? mux_in2 : mux_in1;
assign pwm_out = (counter < threshold);

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
        threshold <= 4'b0000;
    end else begin
        counter <= counter + 1;
        if (counter == 4'b1111) begin
            counter <= 4'b0000;
            threshold <= dac_out;
        end
    end
end

assign pwm = pwm_out;

endmodule