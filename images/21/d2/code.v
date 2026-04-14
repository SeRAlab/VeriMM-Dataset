module pulse_generator (
    input wire clk,
    input wire start,
    input wire [3:0] width,
    output reg pulse
);
    reg [3:0] count;

    always @(posedge clk) begin
        if (start) begin
            count <= width;
            pulse <= 1;
        end else if (count > 0) begin
            count <= count - 1;
            if (count == 1) begin
                pulse <= 0;
            end
        end
    end
endmodule