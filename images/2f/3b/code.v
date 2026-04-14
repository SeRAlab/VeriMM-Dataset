module crystal_oscillator(
    input wire clk_in,
    input wire reset,
    output reg clk_out,
    output reg square_wave
);
    reg [1:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            clk_out <= 0;
            square_wave <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out; // Toggle clk_out every 4 input clock cycles
                square_wave <= ~square_wave; // Toggle square_wave every 2 input clock cycles
                counter <= 2'b00; // Reset counter
            end
        end
    end
endmodule