module binary_search_comparator (
    input [3:0] A,
    input [3:0] B,
    output reg [1:0] result // 00 for A < B, 01 for A == B, 10 for A > B
);
    always @(*) begin
        if (A < B) begin
            result = 2'b00; // A < B
        end else if (A == B) begin
            result = 2'b01; // A == B
        end else begin
            result = 2'b10; // A > B
        end
    end
endmodule