module audio_mux (
    input [7:0] audio_in0,
    input [7:0] audio_in1,
    input [7:0] audio_in2,
    input [7:0] audio_in3,
    input [1:0] select,
    output reg [7:0] audio_out
);

always @(*) begin
    case (select)
        2'b00: audio_out = audio_in0;
        2'b01: audio_out = audio_in1;
        2'b10: audio_out = audio_in2;
        2'b11: audio_out = audio_in3;
        default: audio_out = 8'b00000000; // default case
    endcase
end
endmodule