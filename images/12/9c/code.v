module pulse_generator(
    input clk,
    input reset,
    input activate,
    output reg pulse
);

    reg [2:0] count; // 3-bit counter to count up to 5

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            count <= 0;
        end else if (activate) begin
            pulse <= 1;
            count <= 0;
        end else if (pulse && count < 5) begin
            count <= count + 1;
        end else if (count == 5) begin
            pulse <= 0;
        end
    end
endmodule