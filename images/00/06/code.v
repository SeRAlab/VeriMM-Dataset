module rc_oscillator (
    input wire clk,
    input wire enable,
    output reg out
);
    always @(posedge clk) begin
        if (enable) begin
            out <= ~out; // Toggle output
        end
    end
endmodule