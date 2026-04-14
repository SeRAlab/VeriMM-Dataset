module dac (
    input wire [15:0] din,
    input wire enable,
    output reg [15:0] dout
);
    always @(*) begin
        if (enable) begin
            dout = din; // Direct mapping when enabled
        end else begin
            dout = 16'b0; // Output zero when not enabled
        end
    end
endmodule