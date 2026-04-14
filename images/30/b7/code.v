module phase_shifter (
    input wire clk,
    input wire [2:0] phase_in,
    output reg [2:0] phase_out
);
    always @(posedge clk) begin
        case (phase_in)
            3'b000: phase_out <= 3'b000; // 0 degrees
            3'b001: phase_out <= 3'b001; // 90 degrees
            3'b010: phase_out <= 3'b010; // 180 degrees
            3'b011: phase_out <= 3'b011; // 270 degrees
            default: phase_out <= 3'b000; // default to 0 degrees
        endcase
    end
endmodule