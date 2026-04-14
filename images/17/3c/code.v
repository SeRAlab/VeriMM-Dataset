module ldo_control (
    input [4:0] vin,         // Input voltage (5-bit)
    input control,           // Control signal (1-bit)
    output reg [4:0] vout    // Output regulated voltage (5-bit)
);
    always @(*) begin
        if (control) begin
            vout = vin;       // Output follows input when control is high
        end else begin
            vout = 5'b00000;  // Output is 0 when control is low
        end
    end
endmodule