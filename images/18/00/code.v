module dma_controller (
    input clk,
    input reset,
    input req1,
    input req2,
    output reg grant1,
    output reg grant2
);

    reg [1:0] state; // 0: grant1, 1: grant2, 2: idle
    parameter GRANT1 = 2'b00, GRANT2 = 2'b01, IDLE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            grant1 <= 0;
            grant2 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (req1) begin
                        grant1 <= 1;
                        grant2 <= 0;
                        state <= GRANT1;
                    end else if (req2) begin
                        grant1 <= 0;
                        grant2 <= 1;
                        state <= GRANT2;
                    end
                end
                GRANT1: begin
                    if (!req1) begin
                        grant1 <= 0;
                        state <= IDLE;
                    end
                end
                GRANT2: begin
                    if (!req2) begin
                        grant2 <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule