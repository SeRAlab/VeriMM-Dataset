module sata_controller (
    input clk,
    input reset,
    input start,
    input stop,
    input error,
    output reg [1:0] state // 00: IDLE, 01: ACTIVE, 10: ERROR
);

    // State Encoding
    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    localparam ERROR = 2'b10;

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (stop) state <= IDLE;
                    if (error) state <= ERROR;
                end
                ERROR: begin
                    if (stop) state <= IDLE; // return to IDLE after error
                end
            endcase
        end
    end
endmodule