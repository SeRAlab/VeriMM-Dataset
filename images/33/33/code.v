module decision_tree (
    input wire A,
    input wire B,
    input wire C,
    output reg [1:0] category
);
    always @(*) begin
        if (A == 0) begin
            if (B == 0) begin
                category = 2'b00; // Category 0
            end else begin
                category = 2'b01; // Category 1
            end
        end else begin
            if (C == 0) begin
                category = 2'b10; // Category 2
            end else begin
                category = 2'b11; // Category 3
            end
        end
    end
endmodule