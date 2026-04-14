module branch_predictor(
    input clk,
    input reset,
    input branch_taken,
    output reg predict
);
    reg [1:0] state; // 2-bit saturating counter
    
    // State Encoding
    // 00: Strongly NOT taken
    // 01: Weakly NOT taken
    // 10: Weakly taken
    // 11: Strongly taken
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b01; // Start in weakly not taken state
            predict <= 0;   // Initial prediction is not taken
        end else begin
            case (state)
                2'b00: begin // Strongly NOT taken
                    predict <= 0;
                    if (branch_taken) state <= 2'b01;
                end
                2'b01: begin // Weakly NOT taken
                    predict <= 0;
                    if (branch_taken) state <= 2'b10;
                    else state <= 2'b00;
                end
                2'b10: begin // Weakly taken
                    predict <= 1;
                    if (branch_taken) state <= 2'b11;
                    else state <= 2'b01;
                end
                2'b11: begin // Strongly taken
                    predict <= 1;
                    if (~branch_taken) state <= 2'b10;
                end
            endcase
        end
    end
endmodule