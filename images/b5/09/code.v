module top_module(
    input clk_src,
    input reset,
    input [4:0] clk_sel,
    input M,
    output reg [3:0] state
    );reg [3:0] counter;
    reg [4:0] pattern;

    always @(posedge clk_src or posedge reset) begin
        if (reset) begin
            counter <= 0;
            pattern <= 5'b00000; // Changed to 5'b00000 to match panic
            state <= 4'b0000;
        end else begin
            if (counter == 0) begin
                pattern <= pattern + 1;
                if (pattern > 5'b1001) begin
                    pattern <= 5'b0000;
                end
            end
            
            // Corrected order of the portion of state being rotated
            if (M) begin
                state <= {state[2:0], state[3]};
            end else begin
                state <= {state[0], state[3:1]}; // Fixed out of order part selection
            end
            
            case (pattern)
                5'b00000: state <= 4'b0000;
                5'b00001: state <= 4'b1111;
                5'b00010: state <= {state[2:0], state[3]};
                5'b00011: state <= {state[2:0], 1'b0};
                5'b00100: state <= {1'b0, state[3:1]};
                5'b00101: state <= {state[2:1], state[0]};
                5'b00110: state <= {4{1'b1}} & {4{counter[0]}};
                5'b00111: state <= {4{1'b1}} & {4{counter[1]}};
                5'b01000: state <= {4{1'b1}} & {4{counter[2]}};
                5'b01001: state <= {4{1'b1}} & {4{counter[3]}};
                default: state <= 4'b0000;
            endcase
            
            // Increment and reset the counter
            counter <= counter + 1;
            if (counter == 15) begin
                counter <= 0;
            end
        end
    end
endmodule