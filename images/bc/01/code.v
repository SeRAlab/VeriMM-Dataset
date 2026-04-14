module pulse_generator (
    input clk,
    input reset,
    output reg pulse
);

    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            pulse <= 0;
        end else if (count == 2) begin
            pulse <= 1;
            count <= 0;
        end else begin
            count <= count + 1;
            pulse <= 0;
        end
    end
endmodule