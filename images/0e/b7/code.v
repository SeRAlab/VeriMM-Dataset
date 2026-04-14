module voltage_regulator (
    input [4:0] desired_voltage,
    output reg [4:0] regulated_voltage
);
    
    always @(*) begin
        if (desired_voltage > 5'b11111) begin
            regulated_voltage = 5'b11111; // Clamp to maximum output
        end else begin
            regulated_voltage = desired_voltage; // Pass the input
        end
    end
endmodule