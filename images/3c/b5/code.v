module sata_controller (
    input clk,
    input reset,
    input activate,
    input error,
    output reg [1:0] state // 00: IDLE, 01: ACTIVE, 10: ERROR
);

// State encoding
parameter IDLE = 2'b00;
parameter ACTIVE = 2'b01;
parameter ERROR = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE; // Reset state
    end else begin
        case (state)
            IDLE: begin
                if (activate) begin
                    state <= ACTIVE; // Transition to ACTIVE
                end
            end
            ACTIVE: begin
                if (error) begin
                    state <= ERROR; // Transition to ERROR
                end else if (reset) begin
                    state <= IDLE; // Transition to IDLE
                end
            end
            ERROR: begin
                if (reset) begin
                    state <= IDLE; // Transition to IDLE
                end
            end
        endcase
    end
end

endmodule