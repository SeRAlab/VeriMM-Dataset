module qam_modulator (
    input [3:0] amplitude,
    input [1:0] phase,
    output reg [5:0] qam_signal
);

always @(*) begin
    qam_signal = {amplitude, phase};
end

endmodule