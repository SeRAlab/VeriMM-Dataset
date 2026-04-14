module pulse_generator (
    input wire clk,
    input wire reset,
    input wire trigger,
    output reg pulse
);

    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse <= 0;
            count <= 0;
        end else if (trigger) begin
            if (count < 5) begin
                pulse <= 1;
                count <= count + 1;
            end else begin
                pulse <= 0;
            end
        end else begin
            if (count >= 5) begin
                pulse <= 0;
            end
        end
    end

endmodule