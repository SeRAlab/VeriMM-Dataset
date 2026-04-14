module slam_fsm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire localize_done,
    output reg [1:0] state // 00: Idle, 01: Mapping, 10: Localizing
);

    parameter IDLE = 2'b00, MAPPING = 2'b01, LOCALIZING = 2'b10;
    reg [3:0] count; // Counter for mapping duration

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= MAPPING;
                        count <= 0;
                    end
                end
                MAPPING: begin
                    count <= count + 1;
                    if (count == 4'd5) begin // Stay in mapping state for 5 clock cycles
                        state <= LOCALIZING;
                    end
                end
                LOCALIZING: begin
                    if (localize_done) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule