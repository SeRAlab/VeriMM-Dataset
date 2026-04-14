module zero_crossing_detector(
    input wire clk,
    input wire data,
    output reg crossing
);
    reg data_prev;

    always @(posedge clk) begin
        if (data_prev == 1'b0 && data == 1'b1) begin
            crossing <= 1'b1; // Positive to negative crossing
        end else if (data_prev == 1'b1 && data == 1'b0) begin
            crossing <= 1'b1; // Negative to positive crossing
        end else begin
            crossing <= 1'b0; // No crossing
        end
        data_prev <= data; // Store previous data value
    end
endmodule