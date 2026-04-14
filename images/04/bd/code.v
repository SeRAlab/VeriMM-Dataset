module pulse_generator (
    input clk,
    input start,
    input [3:0] pulse_width,
    output reg pulse_out
);
    reg [3:0] count;

    always @(posedge clk) begin
        if (start) begin
            count <= pulse_width;
            pulse_out <= 1;
        end else if (count > 0) begin
            count <= count - 1;
        end else begin
            pulse_out <= 0;
        end
    end
endmodule