module linear_voltage_regulator (
    input [2:0] ref_voltage, // 3-bit reference voltage input (0 to 7)
    output reg [2:0] out_voltage // 3-bit output voltage (0 to 5)
);
    always @(*) begin
        if (ref_voltage > 3'b101) // If input > 5 (101 in binary), limit to 5
            out_voltage = 3'b101; // Output max 5V (binary 101)
        else
            out_voltage = ref_voltage; // Else output is the same as input
    end
endmodule