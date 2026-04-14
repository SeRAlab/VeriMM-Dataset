module top_module(clk, state);input clk;
    output reg [2:0] state;

    reg [31:0] counter;

    always @(posedge clk)
    begin
        counter <= counter + 1;

        case(state)
            3'b000: // Green state
                begin
                    if(counter >= 10_000_000) // 10 seconds
                    begin
                        counter <= 0;
                        state <= 3'b001; // Switch to yellow
                    end
                end

            3'b001: // Yellow state
                begin
                    if(counter >= 2_000_000) // 2 seconds
                    begin
                        counter <= 0;
                        state <= 3'b010; // Switch to red
                    end
                end

            3'b010: // Red state
                begin
                    if(counter >= 8_000_000) // 8 seconds
                    begin
                        counter <= 0;
                        state <= 3'b000; // Switch to green
                    end
                end
        endcase
    end
endmodule