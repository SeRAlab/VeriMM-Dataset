module top_module(
    input Clk,
    input Reset,
    input [3:0] DutyCycle,
    output reg PWM
);reg [15:0] counter;

always @(posedge Clk) begin
    if (Reset) begin
        counter <= 0;
        PWM <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == 16000) begin
            counter <= 0;
            PWM <= (counter < DutyCycle);
        end
    end
end

endmodule