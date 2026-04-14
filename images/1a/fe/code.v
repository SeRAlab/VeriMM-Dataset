module dma_controller (
    input wire clk,
    input wire reset,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    input wire ack,
    output reg gnt0,
    output reg gnt1,
    output reg gnt2,
    output reg gnt3
);
    reg [1:0] state; // 0: idle, 1: grant channel 0, 2: grant channel 1, 3: grant channel 2, 4: grant channel 3
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            gnt0 <= 0;
            gnt1 <= 0;
            gnt2 <= 0;
            gnt3 <= 0;
        end else begin
            case (state)
                0: begin
                    if (req0) begin
                        gnt0 <= 1;
                        state <= 1;
                    end else if (req1) begin
                        gnt1 <= 1;
                        state <= 2;
                    end else if (req2) begin
                        gnt2 <= 1;
                        state <= 3;
                    end else if (req3) begin
                        gnt3 <= 1;
                        state <= 4;
                    end
                end
                1: begin
                    if (ack) begin
                        gnt0 <= 0;
                        state <= 0;
                    end
                end
                2: begin
                    if (ack) begin
                        gnt1 <= 0;
                        state <= 0;
                    end
                end
                3: begin
                    if (ack) begin
                        gnt2 <= 0;
                        state <= 0;
                    end
                end
                4: begin
                    if (ack) begin
                        gnt3 <= 0;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule