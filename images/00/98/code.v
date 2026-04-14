module slam_fsm (
    input clk,
    input reset,
    input start,
    input map_ready,
    input localize_done,
    output reg [1:0] current_state,
    output reg error
);
    // State encoding
    localparam INIT = 2'b00, MAP = 2'b01, LOCALIZE = 2'b10;
  
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= INIT;
            error <= 0;
        end else begin
            case (current_state)
                INIT: begin
                    if (start) begin
                        current_state <= MAP;
                    end
                    error <= 1;
                end
                MAP: begin
                    if (map_ready) begin
                        current_state <= LOCALIZE;
                    end
                    error <= 0;
                end
                LOCALIZE: begin
                    if (localize_done) begin
                        current_state <= MAP;
                    end
                    error <= 0;
                end
                default: current_state <= INIT;
            endcase
        end
    end
endmodule