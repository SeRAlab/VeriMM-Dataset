module pulse_generator #(parameter N = 10) (
    input wire clk,
    input wire rst,
    output reg pulse
);

reg [31:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pulse <= 0;
        counter <= 0;
    end else begin
        if (counter == N - 1) begin
            pulse <= 1;
            counter <= 0;
        end else begin
            pulse <= 0;
            counter <= counter + 1;
        end
    end
end

endmodule