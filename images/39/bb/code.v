module DAC_8bit (
    input [7:0] din,
    output reg [7:0] dout
);
    always @(*) begin
        dout = din; // Direct mapping from digital input to output
    end
endmodule