module comparator (
    input [15:0] A,
    input [15:0] B,
    output reg result
);

    always @(*) begin
        if (A <= B) begin
            result = 1'b1;
        end else begin
            result = 1'b0;
        end
    end

endmodule