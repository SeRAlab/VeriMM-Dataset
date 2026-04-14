module phase_shifter (
    input wire clk,
    input wire reset,
    input wire [3:0] phase_in,
    output reg [3:0] phase_out
);

    reg [3:0] phase_internal;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase_internal <= 4'b0000; // Reset phase to 0 degrees
        end else begin
            phase_internal <= (phase_internal + 4'b0011) % 4'b1011; // Increment by 45 degrees
        end
    end

    always @(phase_internal) begin
        phase_out = phase_internal;
    end

endmodule