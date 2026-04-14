module pulse_generator(
    input clk,
    input reset,
    input trigger,
    input [2:0] pulse_width,
    output reg pulse
);
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            count <= 0;
        end else if (trigger) begin
            pulse <= 1;
            count <= pulse_width;
        end else if (count > 0) begin
            count <= count - 1;
            if (count == 1) pulse <= 0;
        end
    end
endmodule