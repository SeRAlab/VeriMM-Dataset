module led_controller(
    input clk,
    input enable,
    input blink,
    output reg led
);

    reg [31:0] counter = 0;

    always @(posedge clk) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter[24] == 1) begin // Adjust this value for different blink frequencies
                led <= blink;
            end else begin
                led <= 0;
            end
        end else begin
            led <= 0;
            counter <= 0;
        end
    end

endmodule