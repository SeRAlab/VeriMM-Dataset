module branch_predictor (
    input clk,
    input reset,
    input branch_taken,
    output reg prediction
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initialize to strongly not taken
            prediction <= 0;
        end else begin
            prediction <= (state[1] == 1) ? 1 : 0; // Output prediction based on state

            // Update state based on actual branch outcome
            case (state)
                2'b00: state <= branch_taken ? 2'b01 : 2'b00; // 00 -> 01 or stay 00
                2'b01: state <= branch_taken ? 2'b10 : 2'b00; // 01 -> 10 or go back to 00
                2'b10: state <= branch_taken ? 2'b11 : 2'b01; // 10 -> 11 or go back to 01
                2'b11: state <= branch_taken ? 2'b11 : 2'b10; // 11 -> stay 11 or go back to 10
            endcase
        end
    end
endmodule