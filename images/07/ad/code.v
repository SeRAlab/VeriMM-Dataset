module branch_predictor(
    input clk,
    input actual_outcome,
    output reg prediction
);
    reg [1:0] state;

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                prediction <= 1'b0; // strongly not taken
                if (actual_outcome) state <= 2'b01; // move to weakly not taken
            end
            2'b01: begin
                prediction <= 1'b0; // weakly not taken
                if (actual_outcome) state <= 2'b10; // move to weakly taken
                else state <= 2'b00; // move to strongly not taken
            end
            2'b10: begin
                prediction <= 1'b1; // weakly taken
                if (actual_outcome) state <= 2'b11; // move to strongly taken
                else state <= 2'b01; // move to weakly not taken
            end
            2'b11: begin
                prediction <= 1'b1; // strongly taken
                if (!actual_outcome) state <= 2'b10; // move to weakly taken
            end
        endcase
    end

    initial begin
        state = 2'b00; // initial state
    end
endmodule