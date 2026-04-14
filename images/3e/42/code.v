module branch_predictor (
    input wire clk,
    input wire reset,
    input wire branch_signal,
    input wire actual_outcome,
    output reg taken
);

    reg [1:0] state; // 00: Strongly Not Taken, 01: Weakly Not Taken, 10: Weakly Taken, 11: Strongly Taken

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Start in Strongly Not Taken state
            taken <= 0;
        end else if (branch_signal) begin
            case (state)
                2'b00: begin
                    if (actual_outcome) begin
                        state <= 2'b01; // Move to Weakly Not Taken
                        taken <= 0;     // Predict Not Taken
                    end else begin
                        taken <= 0;     // Predict Not Taken
                    end
                end
                2'b01: begin
                    if (actual_outcome) begin
                        state <= 2'b10; // Move to Weakly Taken
                        taken <= 0;     // Predict Not Taken
                    end else begin
                        state <= 2'b00; // Move to Strongly Not Taken
                        taken <= 0;     // Predict Not Taken
                    end
                end
                2'b10: begin
                    if (actual_outcome) begin
                        state <= 2'b11; // Move to Strongly Taken
                        taken <= 1;     // Predict Taken
                    end else begin
                        state <= 2'b01; // Move to Weakly Not Taken
                        taken <= 1;     // Predict Taken
                    end
                end
                2'b11: begin
                    if (actual_outcome) begin
                        taken <= 1;     // Predict Taken
                    end else begin
                        state <= 2'b10; // Move to Weakly Taken
                        taken <= 1;     // Predict Taken
                    end
                end
            endcase
        end
    end
endmodule