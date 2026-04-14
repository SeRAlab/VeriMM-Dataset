module top_module(
    input signed [15:0] signed_mag,
    output reg signed [15:0] twos_comp
);always @(*) begin
        if (signed_mag >= 0) begin
            twos_comp = signed_mag;
        end else begin
            twos_comp = -signed_mag;
            twos_comp = ~twos_comp + 1;
        end
    end

endmodule