module branch_predictor (
    input clk,
    input rst,
    input branch_decision, // 0 for not taken, 1 for taken
    output reg prediction // 0 for not taken, 1 for taken
);
    reg [1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b01; // Initialize to weakly taken
            prediction <= 0;
        end else begin
            case (counter)
                2'b00: begin
                    prediction <= 0;
                    if (branch_decision)
                        counter <= 2'b01; // Move to weakly taken
                end
                2'b01: begin
                    prediction <= 0;
                    if (branch_decision)
                        counter <= 2'b10; // Move to strongly taken
                    else
                        counter <= 2'b00; // Move to strongly not taken
                end
                2'b10: begin
                    prediction <= 1;
                    if (branch_decision)
                        counter <= 2'b11; // Stay strongly taken
                    else
                        counter <= 2'b01; // Move to weakly taken
                end
                2'b11: begin
                    prediction <= 1;
                    if (~branch_decision)
                        counter <= 2'b10; // Move to strongly taken
                end
            endcase
        end
    end
endmodule