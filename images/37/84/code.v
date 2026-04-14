module dma_controller (
    input clk,
    input rst,
    input req1,
    input req2,
    output reg ack1,
    output reg ack2
);
    reg [1:0] state;

    // State encoding
    localparam IDLE = 2'b00,
               CH1_ACTIVE = 2'b01,
               CH2_ACTIVE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ack1 <= 0;
            ack2 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ack1 <= 0;
                    ack2 <= 0;
                    if (req1) begin
                        state <= CH1_ACTIVE;
                    end else if (req2) begin
                        state <= CH2_ACTIVE;
                    end
                end

                CH1_ACTIVE: begin
                    ack1 <= 1;
                    ack2 <= 0;
                    if (!req1) begin
                        state <= IDLE;
                    end
                end
                
                CH2_ACTIVE: begin
                    ack1 <= 0;
                    ack2 <= 1;
                    if (!req2) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule