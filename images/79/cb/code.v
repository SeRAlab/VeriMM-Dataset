module square_wave_gen(
    input clk,
    output reg square_wave
);

    reg [1:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 2'b10) begin
            square_wave <= ~square_wave;
            counter <= 0;
        end
    end

endmodule