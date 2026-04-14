module pulse_generator (
    input clk,
    input enable,
    input [3:0] pulse_width, // width of the pulse in clock cycles
    output reg pulse
);
    reg [3:0] count;

    always @(posedge clk) begin
        if (enable) begin
            if (count < pulse_width) begin
                pulse <= 1'b1;
                count <= count + 1'b1;
            end else begin
                pulse <= 1'b0;
                count <= 4'b0; // reset count after pulse
            end
        end else begin
            pulse <= 1'b0; // If not enabled, output is low
            count <= 4'b0; // Reset count
        end
    end
endmodule