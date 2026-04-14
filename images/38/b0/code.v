module voltage_regulator (
    input wire [7:0] Vin,       // Input voltage
    input wire select,          // Select signal
    output reg [7:0] Vout       // Output voltage
);
    parameter Vout1 = 8'b00011000; // Example nominal output (24 in decimal)
    parameter Vout2 = 8'b00010000; // Example lower output (16 in decimal)

    always @(*) begin
        if (select) begin
            Vout = Vout2; // Output lower voltage if select is high
        end else begin
            Vout = Vout1; // Output nominal voltage if select is low
        end
    end
endmodule