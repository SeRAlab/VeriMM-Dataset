module dma_controller (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    output reg grant0,
    output reg grant1,
    input wire ack0,
    input wire ack1
);
    
    reg [1:0] state; // 0: idle, 1: channel 0, 2: channel 1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            grant0 <= 0;
            grant1 <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    grant0 <= 0;
                    grant1 <= 0;
                    if (req0) begin
                        state <= 1; // grant channel 0
                    end else if (req1) begin
                        state <= 2; // grant channel 1
                    end
                end
                1: begin // channel 0 granted
                    grant0 <= 1;
                    grant1 <= 0;
                    if (ack0) begin
                        state <= 0; // return to idle
                    end
                end
                2: begin // channel 1 granted
                    grant0 <= 0;
                    grant1 <= 1;
                    if (ack1) begin
                        state <= 0; // return to idle
                    end
                end
                default: state <= 0;
            endcase
        end
    end
endmodule