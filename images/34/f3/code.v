module linear_regulator (
    input wire [7:0] ref_voltage,  // Reference voltage
    input wire [7:0] fb_voltage,   // Feedback voltage
    output reg [1:0] control_signal // Control signal: 00 = Increase, 01 = Decrease, 10 = Maintain
);

always @(*) begin
    if (fb_voltage < ref_voltage) begin
        control_signal = 2'b00; // Increase output
    end else if (fb_voltage > ref_voltage) begin
        control_signal = 2'b01; // Decrease output
    end else begin
        control_signal = 2'b10; // Maintain output
    end
end

endmodule