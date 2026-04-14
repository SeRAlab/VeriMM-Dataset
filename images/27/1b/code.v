module crystal_oscillator (
    input wire clk,          // Clock input
    input wire enable,       // Enable signal
    output reg out          // Output signal
);

always @(posedge clk) begin
    if (enable) begin
        out <= ~out;        // Toggle output on every clock cycle when enabled
    end
end

endmodule