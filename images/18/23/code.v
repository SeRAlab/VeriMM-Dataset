module dma_controller(
    input wire req1,
    input wire req2,
    input wire clk,
    input wire rst,
    output reg ack1,
    output reg ack2,
    output reg busy
);

    reg [1:0] state; // 00: Idle, 01: Transfering from req1, 10: Transfering from req2

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack1 <= 0;
            ack2 <= 0;
            busy <= 0;
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin // Idle
                    ack1 <= 0;
                    ack2 <= 0;
                    if (req1) begin
                        state <= 2'b01; // Go to Transfering from req1
                        busy <= 1;
                    end else if (req2) begin
                        state <= 2'b10; // Go to Transfering from req2
                        busy <= 1;
                    end
                end

                2'b01: begin // Transfering from req1
                    ack1 <= 1;
                    ack2 <= 0;
                    if (!req1) begin
                        ack1 <= 0;
                        state <= 2'b00; // Back to Idle
                        busy <= 0;
                    end
                end

                2'b10: begin // Transfering from req2
                    ack1 <= 0;
                    ack2 <= 1;
                    if (!req2) begin
                        ack2 <= 0;
                        state <= 2'b00; // Back to Idle
                        busy <= 0;
                    end
                end
            endcase
        end
    end
endmodule