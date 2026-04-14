module reset_controller (
    input wire clk,
    input wire reset_n,
    output reg reset_out
);
    parameter CYCLES = 4; // Number of clock cycles to hold reset

    reg [1:0] counter; // 2-bit counter to hold the number of cycles

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            reset_out <= 1'b1; // Assert reset_out high
            counter <= 0; // Reset counter
        end else if (reset_out) begin
            if (counter < CYCLES - 1) begin
                counter <= counter + 1; // Increment counter
            end else begin
                reset_out <= 1'b0; // Deassert reset_out low
            end
        end
    end
endmodule