module branch_predictor (
    input clk,
    input reset,
    input taken, // 1 if the branch was taken, 0 if not taken
    output reg prediction // 1 for taken, 0 for not taken
);

reg [1:0] counter; // 2-bit counter

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 2'b01; // Start with weakly taken
        prediction <= 0;
    end else begin
        case (counter)
            2'b00: begin // Strongly not taken
                if (taken) begin
                    counter <= 2'b01; // Move to weakly taken
                end
                prediction <= 0;
            end
            2'b01: begin // Weakly not taken
                if (taken) begin
                    counter <= 2'b10; // Move to weakly taken
                end else begin
                    counter <= 2'b00; // Stay strong not taken
                end
                prediction <= 0;
            end
            2'b10: begin // Weakly taken
                if (taken) begin
                    counter <= 2'b11; // Move to strongly taken
                end else begin
                    counter <= 2'b01; // Move to weakly not taken
                end
                prediction <= 1;
            end
            2'b11: begin // Strongly taken
                if (taken) begin
                    counter <= 2'b11; // Stay strongly taken
                end else begin
                    counter <= 2'b10; // Move to weakly taken
                end
                prediction <= 1;
            end
        endcase
    end
end

endmodule