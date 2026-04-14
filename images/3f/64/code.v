module switching_regulator(
    input wire ctrl,        // control signal
    input wire [1:0] vin,  // input voltage (2-bit representation)
    output reg vout        // output voltage (1-bit representation)
);
    always @(*) begin
        if (ctrl) begin
            vout = (vin == 2'b01) ? 1'b1 : 1'b0; // Output 3.3V if vin is 5V
        end else begin
            vout = 1'b0; // Output 0V if ctrl is 0
        end
    end
endmodule