module SLAM_State_Machine (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, LOCATING = 2'b01, MAPPING = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= LOCATING;
                LOCATING: if (start) state <= MAPPING;
                MAPPING: if (reset) state <= IDLE;
            endcase
        end
    end
endmodule