module DAC_8bit (
    input [7:0] din,
    output reg [9:0] dout
);
    always @(*) begin
        dout = din * 4; // scale the 8-bit input to 10-bit output
    end
endmodule