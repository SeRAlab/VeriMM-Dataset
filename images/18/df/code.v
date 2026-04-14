module DAC_24bit (
    input wire [23:0] din,      // 24-bit input
    input wire enable,          // Enable signal
    output reg [23:0] dout      // 24-bit output
);
    always @(*) begin
        if (enable) begin
            dout = din;          // Output equals input when enabled
        end else begin
            dout = 24'b0;       // Output is zero when not enabled
        end
    end
endmodule