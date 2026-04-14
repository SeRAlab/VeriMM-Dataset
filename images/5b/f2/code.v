module square_wave_gen(
    input wire clk,
    input wire rst_n,
    output reg square_wave
);

reg toggle;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        square_wave <= 1'b0;
        toggle <= 1'b0;
    end else begin
        toggle <= ~toggle;
        if (toggle)
            square_wave <= ~square_wave;
    end
end

endmodule