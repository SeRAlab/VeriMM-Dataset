module robot_slam (
    input clk,
    input rst,
    input start,
    input map,
    input stop,
    output reg [1:0] state // 00: IDLE, 01: MOVING, 10: MAPPING
);
    // State encoding
    parameter IDLE = 2'b00, MOVING = 2'b01, MAPPING = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= MOVING;
                end
                MOVING: begin
                    if (map) state <= MAPPING;
                    else if (stop) state <= IDLE;
                end
                MAPPING: begin
                    if (stop) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule