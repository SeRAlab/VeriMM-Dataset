module noise_suppression(
    input clk,
    input rst,
    input din,
    output reg dout
);
    reg [1:0] state; // State for counting stable clock cycles
    parameter STABLE = 2'b00, NOISE = 2'b01, DEBOUNCE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 0;
            state <= STABLE;
        end else begin
            case (state)
                STABLE: begin
                    if (din) begin
                        state <= DEBOUNCE;
                        dout <= 1;
                    end
                end
                DEBOUNCE: begin
                    if (din) begin
                        state <= NOISE;
                    end else begin
                        dout <= 0;
                        state <= STABLE;
                    end
                end
                NOISE: begin
                    if (!din) begin
                        dout <= 0;
                        state <= STABLE;
                    end
                end
            endcase
        end
    end
endmodule