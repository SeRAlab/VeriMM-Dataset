module crystal_oscillator #(parameter INPUT_FREQ = 50_000_000, parameter DIV_FACTOR = 2) (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    reg [31:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter >= (INPUT_FREQ / (2 * DIV_FACTOR)) - 1) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule