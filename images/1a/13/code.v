module LDO_Regulator (
    input wire enable,
    input wire [4:0] Vin,  // 5V input in binary representation (0-31)
    output reg [3:0] Vout  // 3.3V output in binary representation (0-15)
);

always @(*) begin
    if (enable) begin
        if (Vin >= 16) // Simulating a regulated output of 3.3V when input is sufficient
            Vout = 4'b1100; // 3.3V in binary representation
        else
            Vout = 4'b0000; // Output 0V if input is not sufficient
    end else begin
        Vout = 4'b0000; // Output 0V when disabled
    end
end

endmodule