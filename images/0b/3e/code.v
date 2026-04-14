module slam_fsm(
    input wire clk,
    input wire reset,
    input wire start,
    input wire map_complete,
    input wire localize_complete,
    output reg [2:0] state
);
    
    // State encoding
    parameter IDLE = 3'b000;
    parameter MAPPING = 3'b001;
    parameter LOCALIZING = 3'b010;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= MAPPING;
                end
                MAPPING: begin
                    if (map_complete) state <= LOCALIZING;
                end
                LOCALIZING: begin
                    if (localize_complete) state <= IDLE;
                end
            endcase
        end
    end
endmodule