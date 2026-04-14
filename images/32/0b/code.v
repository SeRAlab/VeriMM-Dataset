module slam_fsm (
    input wire clk,
    input wire rst,
    input wire start,
    input wire localize,
    input wire stop,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter MAPPING = 2'b01;
    parameter LOCALIZING = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= MAPPING;
                end
                MAPPING: begin
                    if (localize) state <= LOCALIZING;
                    else if (stop) state <= IDLE;
                end
                LOCALIZING: begin
                    if (stop) state <= IDLE;
                end
            endcase
        end
    end
endmodule