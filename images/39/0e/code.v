module monte_carlo_simulation(
    input [7:0] random_number,
    input [7:0] lower_bound,
    input [7:0] upper_bound,
    output reg in_range
);
    always @(*) begin
        if (random_number >= lower_bound && random_number <= upper_bound)
            in_range = 1;
        else
            in_range = 0;
    end
endmodule