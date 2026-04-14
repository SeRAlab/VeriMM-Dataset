module top_module(
        input clk_i,
        input rst_i,
        output reg [2:0] count_o
    );// Define the states of the finite state machine
    parameter [1:0] IDLE = 2'b00;
    parameter [1:0] COUNT = 2'b01;

    // Define the current state of the finite state machine
    reg [1:0] state;

    always @(posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            // Reset the counter to zero
            state <= IDLE;
            count_o <= 3'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    // Wait for the next clock cycle to start counting
                    state <= COUNT;
                end
                COUNT: begin
                    // Increment the counter and reset it to zero if it reaches its maximum value
                    if (count_o == 3'b111) begin
                        count_o <= 3'b0;
                        state <= IDLE;
                    end
                    else begin
                        count_o <= count_o + 3'b1;
                        state <= COUNT;
                    end
                end
                default: begin
                    // Should never happen
                    state <= IDLE;
                    count_o <= 3'b0;
                end
            endcase
        end
    end
endmodule