module vco (
    input wire clk,
    input wire [3:0] control_voltage,
    output reg square_wave
);
    reg [23:0] counter;
    parameter BASE_FREQ = 1; // base frequency unit for toggling

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= (BASE_FREQ << control_voltage)) begin
            square_wave <= ~square_wave;
            counter <= 0;
        end
    end

    initial begin
        square_wave = 0;
        counter = 0;
    end
endmodule