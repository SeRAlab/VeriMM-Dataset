module traffic_light (
    input clk,
    input areset,
    output reg [1:0] state);

    parameter RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10;
    reg [2:0] count;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= RED;
            count <= 3'd0;
        end else begin
            case (state)
                GREEN: begin
                    if (count < 3'd4) count <= count + 3'd1;
                    else begin
                        state <= YELLOW;
                        count <= 3'd0;
                    end
                end
                YELLOW: begin
                    if (count < 3'd1) count <= count + 3'd1;
                    else begin
                        state <= RED;
                        count <= 3'd0;
                    end
                end
                RED: begin
                    if (count < 3'd2) count <= count + 3'd1;
                    else begin
                        state <= GREEN;
                        count <= 3'd0;
                    end
                end
            endcase
        end
    end
endmodule