module traffic_light_controller (
    input wire clk,
    input wire reset,
    output reg [1:0] state // 00: RED, 01: GREEN, 10: YELLOW
);
    parameter RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10;
    reg [2:0] count; // Counter for timing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RED;
            count <= 0;
        end else begin
            case (state)
                RED: begin
                    if (count < 5) begin
                        count <= count + 1;
                    end else begin
                        state <= GREEN;
                        count <= 0;
                    end
                end
                GREEN: begin
                    if (count < 3) begin
                        count <= count + 1;
                    end else begin
                        state <= YELLOW;
                        count <= 0;
                    end
                end
                YELLOW: begin
                    if (count < 2) begin
                        count <= count + 1;
                    end else begin
                        state <= RED;
                        count <= 0;
                    end
                end
            endcase
        end
    end
endmodule