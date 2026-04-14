module slam_fsm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire map,
    output reg [1:0] state
);

    // State definitions
    parameter IDLE = 2'b00, LOCALIZE = 2'b01, MAP = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start)
                        state <= LOCALIZE;
                end
                LOCALIZE: begin
                    if (map)
                        state <= MAP;
                end
                MAP: begin
                    state <= IDLE;  // Return to IDLE after mapping
                end
            endcase
        end
    end
endmodule