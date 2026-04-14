module comparator_32bit (
    input [31:0] A,
    input [31:0] B,
    output reg [1:0] result
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