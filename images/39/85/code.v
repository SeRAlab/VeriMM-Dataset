module dac_8bit (
    input [7:0] din,
    output reg [2:0] dout
);
    always @(*) begin
        dout = (din * 7 + 127) / 255; // Rounding to the nearest integer
    end
endmodule