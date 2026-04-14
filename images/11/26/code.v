module pll_8x (
    input wire clk_ref,          // Reference clock input
    input wire rst,             // Reset signal
    input wire feedback_signal,  // Feedback signal to determine lock status
    output reg clk_out,         // Output clock
    output reg locked           // Lock status
);
    reg [2:0] state;            // State variable for the PLL
    parameter UNLOCKED = 3'b000, LOCKED = 3'b001;

    always @(posedge clk_ref or posedge rst) begin
        if (rst) begin
            state <= UNLOCKED;
            locked <= 0;
            clk_out <= 0;
        end else begin
            case (state)
                UNLOCKED: begin
                    if (feedback_signal) begin
                        state <= LOCKED;
                        locked <= 1;
                    end
                end
                LOCKED: begin
                    if (!feedback_signal) begin
                        state <= UNLOCKED;
                        locked <= 0;
                    end
                end
            endcase
        end
    end

    always @(posedge clk_ref) begin
        if (locked) begin
            clk_out <= ~clk_out; // Toggle output clock when locked
        end
    end
endmodule