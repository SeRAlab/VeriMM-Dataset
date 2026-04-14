module top_module(
    input wire clk,
    input wire [11:0] light_level_adc,
    output reg light
);reg current_status;
integer low_light_level = 2048;

always @(posedge clk)
    if (!current_status)
        if (light_level_adc < low_light_level)
            begin
                current_status <= 1;
                light <= 1;
            end

endmodule