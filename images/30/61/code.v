module monte_carlo_simulation(
    input [4:0] random_number,
    output reg in_range
);
    always @(*) begin
        if (random_number >= 5'd10 && random_number <= 5'd20)
            in_range = 1'b1;
        else
            in_range = 1'b0;
    end
endmodule