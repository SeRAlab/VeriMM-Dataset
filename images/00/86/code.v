module sd_card_interface(
    input clk,
    input reset,
    input start,
    input read_enable,
    input write_enable,
    output reg [2:0] state // 3-bit state representation
);

    // State encoding
    parameter IDLE = 3'b000,
              INIT = 3'b001,
              READ = 3'b010,
              WRITE = 3'b011,
              ERROR = 3'b100;
    
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= INIT;
                end
                INIT: begin
                    state <= READ; // Assume initialization is successful
                end
                READ: begin
                    if (read_enable) state <= READ; // Stay in READ if still reading
                    else state <= IDLE; // Go back to IDLE when done
                end
                WRITE: begin
                    if (write_enable) state <= WRITE; // Stay in WRITE if still writing
                    else state <= IDLE; // Go back to IDLE when done
                end
                ERROR: begin
                    state <= IDLE; // Reset on error
                end
                default: state <= ERROR; // Transition to ERROR state on unexpected state
            endcase
        end
    end
endmodule