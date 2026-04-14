module greater_of_two (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] G
);

    always @(*) begin
        if (A > B) begin
            G = A;
        end
        else begin
            G = B;
        end
    end

endmodule