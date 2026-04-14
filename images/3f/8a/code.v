module PLL (
    input clk_in,
    input reset,
    input signal_in,
    output reg clk_out
);
    reg [2:0] phase_counter;
    reg [1:0] state;

    // State encoding
    localparam IDLE = 2'b00, LOCKED = 2'b01, ADJUST = 2'b10;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            phase_counter <= 3'b000;
            state <= IDLE;
            clk_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (signal_in) begin
                        clk_out <= ~clk_out; // Toggle clock
                        phase_counter <= phase_counter + 1;
                        if (phase_counter == 3'b111) begin
                            state <= LOCKED; // Enter locked state
                        end
                    end
                end
                LOCKED: begin
                    if (~signal_in) begin
                        clk_out <= ~clk_out; // Maintain clock
                    end else begin
                        state <= ADJUST; // Start adjusting
                    end
                end
                ADJUST: begin
                    clk_out <= ~clk_out; // Adjust clock
                    state <= LOCKED; // Return to locked state
                end
            endcase
        end
    end
endmodule