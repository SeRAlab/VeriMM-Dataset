module SLAM_FSM (
    input wire clk,
    input wire reset,
    input wire start_map,
    input wire start_navigate,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, MAP = 2'b01, NAVIGATE = 2'b10;
    
    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start_map) state <= MAP;
                MAP: if (start_navigate) state <= NAVIGATE;
                NAVIGATE: if (reset) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule