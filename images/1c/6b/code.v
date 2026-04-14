module pulse_generator(
    input wire clk,
    input wire reset,
    input wire start,
    output reg pulse
);
    parameter PULSE_WIDTH = 5; // Specify pulse width in clock cycles
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            counter <= 0;
        end else if (start) begin
            pulse <= 1; // Start pulse
            counter <= PULSE_WIDTH;
        end else if (counter > 0) begin
            counter <= counter - 1;
            if (counter == 1) begin
                pulse <= 0; // End pulse
            end
        end
    end
endmodule