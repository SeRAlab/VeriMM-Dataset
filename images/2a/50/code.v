module sata_controller (
    input clk,
    input rst,
    input start,
    input stop,
    input error,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, ACTIVE = 2'b01, ERROR = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= ACTIVE;
                ACTIVE: begin
                    if (error) state <= ERROR;
                    else if (stop) state <= IDLE;
                end
                ERROR: if (rst) state <= IDLE; // Return to IDLE on reset
            endcase
        end
    end
endmodule