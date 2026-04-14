module phase_shifter (
    input clk,
    input [2:0] phase_in,
    output reg phase_out
);

    reg [2:0] delay_counter;

    always @(posedge clk) begin
        if (delay_counter < phase_in) begin
            delay_counter <= delay_counter + 1;
            phase_out <= 0; // Output low during the delay
        end else begin
            phase_out <= 1; // Output high after the delay
        end
    end

    always @(posedge clk) begin
        if (delay_counter >= phase_in) begin
            delay_counter <= 0; // Reset the counter
        end
    end

endmodule