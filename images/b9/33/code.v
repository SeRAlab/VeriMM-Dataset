module traffic_light_controller (
    input clk,
    input areset,
    output reg [1:0] ns_light, // 2'b00: Red, 2'b01: Green, 2'b10: Yellow
    output reg [1:0] ew_light);

    parameter RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10;
    reg [3:0] count;
    reg [1:0] state;

    parameter NS_GREEN = 2'b00, NS_YELLOW = 2'b01, EW_GREEN = 2'b10, EW_YELLOW = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= NS_GREEN;
            count <= 4'd0;
        end else begin
            case (state)
                NS_GREEN: begin
                    if (count < 4'd9) count <= count + 4'd1;
                    else begin
                        state <= NS_YELLOW;
                        count <= 4'd0;
                    end
                end
                NS_YELLOW: begin
                    if (count < 4'd2) count <= count + 4'd1;
                    else begin
                        state <= EW_GREEN;
                        count <= 4'd0;
                    end
                end
                EW_GREEN: begin
                    if (count < 4'd9) count <= count + 4'd1;
                    else begin
                        state <= EW_YELLOW;
                        count <= 4'd0;
                    end
                end
                EW_YELLOW: begin
                    if (count < 4'd2) count <= count + 4'd1;
                    else begin
                        state <= NS_GREEN;
                        count <= 4'd0;
                    end
                end
            endcase
        end
    end

    always @(state) begin
        case (state)
            NS_GREEN: begin
                ns_light = GREEN;
                ew_light = RED;
            end
            NS_YELLOW: begin
                ns_light = YELLOW;
                ew_light = RED;
            end
            EW_GREEN: begin
                ns_light = RED;
                ew_light = GREEN;
            end
            EW_YELLOW: begin
                ns_light = RED;
                ew_light = YELLOW;
            end
        endcase
    end
endmodule