module sata_controller (
    input clk,
    input reset,
    input start,
    input error,
    input operation_complete,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00,
               ACTIVE = 2'b01,
               ERROR = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (error) state <= ERROR;
                    else if (operation_complete) state <= IDLE;
                end
                ERROR: begin
                    if (operation_complete) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule