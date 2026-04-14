module voltage_sensor (
    input [4:0] voltage_input,
    input [4:0] threshold,
    output reg output_signal
);

always @(*) begin
    if (voltage_input < threshold) 
        output_signal = 0;
    else 
        output_signal = 1;
end
endmodule