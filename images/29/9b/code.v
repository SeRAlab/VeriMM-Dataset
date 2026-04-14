module dma_controller(
    input wire clk,
    input wire reset,
    input wire request_a,
    input wire request_b,
    output reg grant_a,
    output reg grant_b
);
    reg state; // 0 for channel A, 1 for channel B
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            grant_a <= 0;
            grant_b <= 0;
        end else begin
            if (request_a || request_b) begin
                case (state)
                    0: begin
                        if (request_a) begin
                            grant_a <= 1;
                            grant_b <= 0;
                        end else if (request_b) begin
                            grant_a <= 0;
                            grant_b <= 1;
                            state <= 1; // switch to channel B
                        end
                    end
                    1: begin
                        if (request_b) begin
                            grant_a <= 0;
                            grant_b <= 1;
                        end else if (request_a) begin
                            grant_a <= 1;
                            grant_b <= 0;
                            state <= 0; // switch to channel A
                        end
                    end
                endcase
            end else begin
                grant_a <= 0;
                grant_b <= 0;
            end
        end
    end
endmodule