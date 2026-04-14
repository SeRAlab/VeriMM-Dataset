module pulse_generator(
    input clk,
    input reset,
    input trigger,
    input [3:0] pulse_width,
    output reg pulse_out
);
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            pulse_out <= 0;
        end else if (trigger) begin
            count <= pulse_width;
            pulse_out <= 1;
        end else if (count > 0) begin
            count <= count - 1;
            if (count == 1) begin
                pulse_out <= 0;
            end
        end
    end
endmodule