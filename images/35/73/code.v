module pulse_generator (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] width,
    output reg pulse
);
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            count <= 0;
        end else begin
            if (enable) begin
                if (width > 0 && count < width) begin
                    pulse <= 1;
                    count <= count + 1;
                end else begin
                    pulse <= 0;
                    count <= 0;
                end
            end else begin
                pulse <= 0;
                count <= 0;
            end
        end
    end
endmodule