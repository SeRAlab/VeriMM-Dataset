module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] product
);reg [3:0] shifted_B;
reg [3:0] i;

always @ (A or B) begin
    product <= 0;
    shifted_B <= B;
    for (i = 0; i < 4; i = i + 1) begin
        if (A[i] == 1) begin
            product <= product + (shifted_B << i);
        end
    end
end

endmodule