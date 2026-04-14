module pulse_generator(
    input wire clk,
    input wire reset,
    input wire trigger,
    output reg pulse
);
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            counter <= 0;
        end else if (trigger) begin
            pulse <= 1;
            counter <= 0;
        end else if (pulse) begin
            if (counter < 10) begin
                counter <= counter + 1;
            end else begin
                pulse <= 0;
            end
        end
    end
endmodule