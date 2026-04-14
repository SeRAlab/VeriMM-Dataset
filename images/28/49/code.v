module pulse_generator (
    input wire clk,
    input wire reset,
    input wire trigger,
    input wire [3:0] pulse_width, // pulse width in clock cycles
    output reg pulse
);
    reg [3:0] counter;
    reg generating;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            counter <= 0;
            generating <= 0;
        end else if (trigger && !generating) begin
            generating <= 1;
            counter <= pulse_width;
            pulse <= 1;
        end else if (generating) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                generating <= 0;
                pulse <= 0;
            end
        end
    end
endmodule