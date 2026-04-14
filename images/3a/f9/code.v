module knn_classifier (
    input [2:0] sample,
    output reg [1:0] classification
);
    always @(*) begin
        case (sample)
            3'b000: classification = 2'b00; // Class 0
            3'b001: classification = 2'b00; // Class 0
            3'b010: classification = 2'b01; // Class 1
            3'b011: classification = 2'b01; // Class 1
            3'b100: classification = 2'b10; // Class 2
            default: classification = 2'b11; // Unknown class
        endcase
    end
endmodule