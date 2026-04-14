module branch_predictor(
    input wire clk,
    input wire rst,
    input wire branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);
    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b00; // Reset to strongly not taken
            prediction <= 0; // Initial prediction is not taken
        end else begin
            case (counter)
                2'b00: begin
                    prediction <= 0; // strongly not taken
                    if (branch_outcome) counter <= 2'b01; // move to weakly not taken
                end
                2'b01: begin
                    prediction <= 0; // weakly not taken
                    if (branch_outcome) counter <= 2'b10; // move to weakly taken
                    else counter <= 2'b00; // move to strongly not taken
                end
                2'b10: begin
                    prediction <= 1; // weakly taken
                    if (branch_outcome) counter <= 2'b11; // move to strongly taken
                    else counter <= 2'b01; // move to weakly not taken
                end
                2'b11: begin
                    prediction <= 1; // strongly taken
                    if (!branch_outcome) counter <= 2'b10; // move to weakly taken
                end
            endcase
        end
    end
endmodule