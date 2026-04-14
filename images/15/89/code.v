module sd_card_interface (
    input wire clk,
    input wire reset,
    input wire [1:0] state_signal,
    output reg [1:0] current_state
);
    // State encoding
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE; // Reset to IDLE
        end else begin
            case (state_signal)
                IDLE: current_state <= IDLE;
                READ: current_state <= READ;
                WRITE: current_state <= WRITE;
                ERROR: current_state <= ERROR;
                default: current_state <= ERROR; // Default to ERROR state
            endcase
        end
    end
endmodule