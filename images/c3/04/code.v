module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg [1:0] result
);

    always @(*) begin
        if (A[3] == 1 && B[3] == 0) begin
            result = 2'b01;
        end else if (A[3] == 0 && B[3] == 1) begin
            result = 2'b10;
        end else begin
            if (A[3:0] > B[3:0]) begin
                result = 2'b01;
            end else if (A[3:0] < B[3:0]) begin
                result = 2'b10;
            end else begin
                result = 2'b00;
            end
        end
    end

endmodule