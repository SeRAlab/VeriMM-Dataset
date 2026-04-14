module top_module(
    input [3:0] signed_mag,
    output reg [3:0] twos_comp
);always @(*) begin
        if (signed_mag[3] == 1) begin
            twos_comp = ~(signed_mag) + 1;
        end else begin
            twos_comp = signed_mag;
        end
    end

endmodule