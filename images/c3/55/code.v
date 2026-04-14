module max_value (
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] max
);

    always @* begin
        if (A > B) begin
            max = A;
        end
        else begin
            max = B;
        end
    end

endmodule