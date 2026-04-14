module traffic_light_controller(
    input wire clk,
    input wire rst,
    output reg [1:0] state // 00: GREEN, 01: YELLOW, 10: RED
);

    // State encoding
    localparam GREEN = 2'b00;
    localparam YELLOW = 2'b01;
    localparam RED = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= GREEN;
        end else begin
            case (state)
                GREEN: state <= YELLOW;
                YELLOW: state <= RED;
                RED: state <= GREEN;
                default: state <= GREEN; // default state
            endcase
        end
    end
endmodule