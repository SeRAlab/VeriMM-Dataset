module top_module(
    input signed [9:0] temp_C,
    input reset,
    output signed [15:0] temp_F
);reg signed [15:0] temp_F_reg;

always @(temp_C, reset) begin
    if (reset) begin
        temp_F_reg <= 16'b0;
    end else begin
        temp_F_reg <= (temp_C * 1.8) + 32;
    end
end

assign temp_F = temp_F_reg;

endmodule