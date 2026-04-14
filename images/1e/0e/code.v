module deserializer (
    input clk,
    input reset,
    input [15:0] parallel_in,
    output reg serial_out
);
    reg [3:0] counter; // 4-bit counter to track output bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            serial_out <= 0;
        end else if (counter < 16) begin
            serial_out <= parallel_in[15 - counter]; // Shift out from MSB to LSB
            counter <= counter + 1;
        end
    end
endmodule