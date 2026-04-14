module sequence_detector_1101 (
    input clk,
    input areset,
    input bit_in,
    output reg detected);

    parameter IDLE = 3'b000, S1 = 3'b001, S11 = 3'b010, S110 = 3'b011, S1101 = 3'b100;
    reg [2:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            detected <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (bit_in) state <= S1;
                    detected <= 1'b0;
                end
                S1: begin
                    if (bit_in) state <= S11;
                    else state <= IDLE;
                    detected <= 1'b0;
                end
                S11: begin
                    if (!bit_in) state <= S110;
                    else state <= S1;
                    detected <= 1'b0;
                end
                S110: begin
                    if (bit_in) begin
                        state <= S1101;
                        detected <= 1'b1;
                    end else begin
                        state <= IDLE;
                        detected <= 1'b0;
                    end
                end
                S1101: begin
                    if (bit_in) state <= S1;
                    else state <= IDLE;
                    detected <= 1'b0;
                end
                default: begin
                    state <= IDLE;
                    detected <= 1'b0;
                end
            endcase
        end
    end
endmodule