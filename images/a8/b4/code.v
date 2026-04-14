module square_wave_generator(
    input wire clk,
    input wire rst_n,
    input wire [3:0] divisor,
    output reg square_wave
);

reg [3:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'd0;
        square_wave <= 1'b0;
    end else begin
        if (counter >= (divisor - 1)) begin
            counter <= 4'd0;
            square_wave <= ~square_wave;
        end else begin
            counter <= counter + 4'd1;
        end
    end
end

endmodule