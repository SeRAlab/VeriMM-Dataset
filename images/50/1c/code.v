module top_module(clk, reset, button_a, button_b, red_a, green_a, red_b, green_b);input clk, reset, button_a, button_b;
output reg red_a, green_a, red_b, green_b;

integer state;
reg [3:0] cnt;

always @(posedge clk, posedge reset)
begin
    if (reset)
    begin
        state <= 0;
        cnt <= 0;
        red_a <= 1;
        green_a <= 0;
        red_b <= 1;
        green_b <= 0;
    end
    else
    begin
        case (state)
            0: begin
                red_a <= 1;
                green_a <= 0;
                red_b <= 1;
                green_b <= 0;
                if (button_a && !button_b)
                    state <= 1;
                else if (!button_a && button_b)
                    state <= 2;
            end
            1: begin
                red_a <= 0;
                green_a <= 1;
                if (cnt == 5)
                begin
                    state <= 3;
                    cnt <= 0;
                end
                else
                    cnt <= cnt + 1;
            end
            2: begin
                red_b <= 0;
                green_b <= 1;
                if (cnt == 5)
                begin
                    state <= 4;
                    cnt <= 0;
                end
                else
                    cnt <= cnt + 1;
            end
            3: begin
                green_a <= 0;
                if (cnt == 1)
                begin
                    state <= 0;
                    cnt <= 0;
                    red_a <= 1;
                end
                else
                    cnt <= cnt + 1;
            end
            4: begin
                green_b <= 0;
                if (cnt == 1)
                begin
                    state <= 0;
                    cnt <= 0;
                    red_b <= 1;
                end
                else
                    cnt <= cnt + 1;
            end
        endcase
    end
end

endmodule