module voltage_sensor (
    input [4:0] voltage_in,
    input [4:0] threshold,
    output reg alarm
);

always @(*) begin
    if (voltage_in > threshold)
        alarm = 1'b1;
    else
        alarm = 1'b0;
end

endmodule