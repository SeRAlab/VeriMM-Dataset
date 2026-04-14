module branch_predictor(
    input wire clk,
    input wire rst,
    input wire actual_outcome,
    output reg predicted_outcome
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            predicted_outcome <= 0; // Initialize the predictor
        end else begin
            predicted_outcome <= actual_outcome; // Update prediction based on actual outcome
        end
    end
endmodule