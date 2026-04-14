module voltage_regulator (
    input [4:0] desired_voltage,
    output reg [4:0] output_voltage
);
    always @(*) begin
        if (desired_voltage > 31) 
            output_voltage = 5'b11111; // 31
        else 
            output_voltage = 31 - desired_voltage;
    end
endmodule