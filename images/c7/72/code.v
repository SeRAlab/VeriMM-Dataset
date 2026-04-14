module multiplier(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] result
);

    always @* begin
        result = {A, 4'b0} * {B, 4'b0};
    end

endmodule