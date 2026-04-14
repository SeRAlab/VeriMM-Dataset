module monte_carlo(
    input [4:0] random_number,
    output reg is_even
);
    always @(*) begin
        is_even = (random_number % 2 == 0) ? 1 : 0;
    end
endmodule