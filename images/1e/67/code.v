module nvme_controller (
    input clk,
    input rst,
    input [1:0] ctrl,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE  = 2'b00;
    localparam READ  = 2'b01;
    localparam WRITE = 2'b10;

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (ctrl)
                2'b00: state <= IDLE;   // Stay in IDLE
                2'b01: state <= READ;   // Transition to READ
                2'b10: state <= WRITE;  // Transition to WRITE
                2'b11: state <= IDLE;   // Return to IDLE
                default: state <= IDLE;  // Default to IDLE
            endcase
        end
    end
endmodule