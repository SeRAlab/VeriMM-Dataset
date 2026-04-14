module power_gating(
    input wire enable,
    input wire power_gating,
    input wire A,
    input wire B,
    input wire C,
    output reg Y
);
    initial begin
        Y = 0; // Initial value
    end

    always @(*) begin
        if (enable) begin
            if (power_gating) begin
                Y = 0; // Power gated
            end else begin
                Y = A & B & C; // Normal operation
            end
        end
    end
endmodule