module linear_regulator(
    input [7:0] Vin,         // Input voltage (8 bits)
    input [2:0] control_signal, // Control signal for gain (3 bits)
    output reg [7:0] Vout,   // Output voltage (8 bits)
    output reg ready         // Ready signal
);

    always @(*) begin
        // Calculate output voltage based on control signal
        Vout = Vin * control_signal / 8;
        
        // Indicate that output is ready
        ready = 1'b1;
    end
endmodule