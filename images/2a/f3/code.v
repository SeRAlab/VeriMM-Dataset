module traffic_light_fsm (
    input clk,
    input rst,
    input enable,
    output reg [1:0] state // 00: Green, 01: Yellow, 10: Red
);

    reg [3:0] counter; // To count time units

    parameter GREEN = 2'b00, YELLOW = 2'b01, RED = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= GREEN;
            counter <= 0;
        end else if (enable) begin
            case (state)
                GREEN: begin
                    if (counter < 10)
                        counter <= counter + 1;
                    else begin
                        state <= YELLOW;
                        counter <= 0;
                    end
                end
                YELLOW: begin
                    if (counter < 3)
                        counter <= counter + 1;
                    else begin
                        state <= RED;
                        counter <= 0;
                    end
                end
                RED: begin
                    if (counter < 10)
                        counter <= counter + 1;
                    else begin
                        state <= GREEN;
                        counter <= 0;
                    end
                end
            endcase
        end
    end
endmodule