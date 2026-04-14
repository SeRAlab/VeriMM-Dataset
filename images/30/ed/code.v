module voltage_sensor (
    input [2:0] voltage_in,
    output reg voltage_ok
);

always @(*) begin
    if (voltage_in >= 3 && voltage_in <= 5) 
        voltage_ok = 1'b1; 
    else 
        voltage_ok = 1'b0; 
end

endmodule