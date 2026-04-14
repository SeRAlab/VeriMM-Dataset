module linear_voltage_regulator (
    input wire [4:0] control,     // control signal (0 or 1)
    input wire [4:0] vin,         // input voltage (in binary)
    output reg [4:0] vout         // output voltage (regulated)
);
    always @(*) begin
        if (vin > 5'b01111) begin // if vin > 3.3V (which is 5'b01101)
            vout = (control == 5'b00001) ? 5'b11111 : 5'b00000; // 5V or 0V
        end else begin
            vout = 5'b00000; // if vin <= 3.3V, output 0V
        end
    end
endmodule