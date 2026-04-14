module top_module(
    input clk,
    input reset,          // Synchronous active-high reset
    output reg led);// Output for the LED controlled by the counter outputs

    reg [3:0] sync_counter;
    reg [3:0] async_counter;
    reg [2:0] pattern_counter;
    reg [2:0] pattern;

    always @(posedge clk) begin
        if (reset) begin
            sync_counter <= 0;
            async_counter <= 0;
            pattern_counter <= 0;
            pattern <= 3'b001;
            led <= 0;
        end else begin
            sync_counter <= sync_counter + 1;
            async_counter <= async_counter + 1;
            pattern_counter <= pattern_counter + 1;

            if (sync_counter == 10) begin
                sync_counter <= 0;
            end

            if (async_counter == 16) begin
                async_counter <= 0;
            end

            if (pattern_counter == 10) begin
                pattern_counter <= 0;
                pattern <= pattern + 1;
                if (pattern == 3'b100) begin
                    pattern <= 3'b001;
                end
            end

            case (pattern)
                3'b001: led <= (sync_counter < 3) ? 1 : 0;
                3'b010: led <= (sync_counter < 2) ? 1 : 0;
                3'b011: led <= (sync_counter < 2) ? 1 : 0;
                3'b100: led <= 0;
            endcase
        end
    end

endmodule