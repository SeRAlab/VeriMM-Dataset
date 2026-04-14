module power_gated_decoder (
    input [1:0] in,
    input power_gating,
    output reg [3:0] out
);
    always @(*) begin
        if (power_gating) begin
            out = 4'b0000;  // Outputs are disabled
        end else begin
            case (in)
                2'b00: out = 4'b0001; // Output 0
                2'b01: out = 4'b0010; // Output 1
                2'b10: out = 4'b0100; // Output 2
                2'b11: out = 4'b1000; // Output 3
                default: out = 4'b0000;
            endcase
        end
    end
endmodule