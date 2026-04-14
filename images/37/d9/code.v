module branch_predictor (
    input wire [1:0] prediction_in,
    input wire [1:0] outcome,
    output reg [1:0] prediction_out
);
    always @(prediction_in or outcome) begin
        case (prediction_in)
            2'b00: prediction_out = (outcome == 2'b00) ? 2'b00 : 2'b01; // Correct, stay in 00, else move to 01
            2'b01: prediction_out = (outcome == 2'b00) ? 2'b00 : 2'b10; // Correct, move to 00, else move to 10
            2'b10: prediction_out = (outcome == 2'b00) ? 2'b01 : 2'b11; // Correct, move to 01, else move to 11
            2'b11: prediction_out = (outcome == 2'b00) ? 2'b10 : 2'b11; // Correct, move to 10, else stay in 11
            default: prediction_out = 2'b00; // Default case
        endcase
    end
endmodule