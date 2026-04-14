module monte_carlo_sim (
    input [4:0] random_num,
    input ctrl,
    output reg [4:0] output_num
);

always @(*) begin
    if (ctrl) begin
        output_num = random_num * random_num; // Squared value of random_num
    end else begin
        output_num = ~random_num; // Inverted value of random_num
    end
end

endmodule