module rc_oscillator (
    input wire clk,
    input wire rst,
    input wire enable,
    output reg out
);
    reg [23:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            out <= 0;
        end else if (enable) begin
            if (counter == 24'd12499999) begin // Adjust this value for frequency
                out <= ~out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            out <= 0; // Disable output when not enabled
        end
    end
endmodule