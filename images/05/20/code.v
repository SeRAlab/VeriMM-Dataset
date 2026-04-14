module rc_oscillator (
    input wire clk,
    input wire rst,
    output reg out
);
    reg [23:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 24'd1250000) begin // Adjust value based on desired frequency
                out <= ~out;
                counter <= 0;
            end
        end
    end
endmodule