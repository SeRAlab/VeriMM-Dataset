module monte_carlo_die(
    input [2:0] random_num,
    output reg success
);
    always @(*) begin
        if (random_num > 3) 
            success = 1;
        else 
            success = 0;
    end
endmodule