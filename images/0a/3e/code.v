module multiplier_4bit (
    input [3:0] A,
    input [3:0] B,
    input valid,
    input reset,
    output reg [7:0] product
);
    always @(*) begin
        if (reset) begin
            product = 8'b0;
        end else if (valid) begin
            product = A * B;
        end else begin
            product = product; // Hold previous value if not valid
        end
    end
endmodule