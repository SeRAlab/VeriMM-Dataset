module phase_shifter (
    input wire clk,
    input wire rst,
    input wire sig_in,
    input wire [1:0] phase_select,
    output reg sig_out
);

reg [1:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sig_out <= 0;
        state <= 0;
    end else begin
        case (phase_select)
            2'b00: sig_out <= sig_in;     // 0 degrees
            2'b01: sig_out <= sig_in ^ 1; // 90 degrees (inverter for demo)
            2'b10: sig_out <= sig_in;     // 180 degrees (same as 0 degrees for simplicity)
            2'b11: sig_out <= sig_in ^ 1; // 270 degrees (same as 90 degrees for simplicity)
            default: sig_out <= sig_in;   // Default to no shift
        endcase
    end
end

endmodule