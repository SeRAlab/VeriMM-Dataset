module traffic_light (
    input clk,
    input areset,
    output reg [1:0] state);

    parameter GREEN_NS = 2'b00, YELLOW_NS = 2'b01, GREEN_EW = 2'b10, YELLOW_EW = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= GREEN_NS;
        end else begin
            case (state)
                GREEN_NS: state <= YELLOW_NS;
                YELLOW_NS: state <= GREEN_EW;
                GREEN_EW: state <= YELLOW_EW;
                YELLOW_EW: state <= GREEN_NS;
                default: state <= GREEN_NS;
            endcase
        end
    end
endmodule