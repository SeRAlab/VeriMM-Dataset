module mul_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [7:0] result
    );

reg [7:0] product;
integer i;

always@(*) begin
    product = 8'b0;
    for (i = 0; i < 4; i = i + 1) begin
        if (A[i]) begin
            product = product + (B << i);
        end
    end
end

assign result = product;

endmodule