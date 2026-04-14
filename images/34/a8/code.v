module audio_mux (
    input [15:0] audio_in1,
    input [15:0] audio_in2,
    input select,
    output reg [15:0] audio_out
);

always @(*) begin
    if (select == 0) 
        audio_out = audio_in1;
    else 
        audio_out = audio_in2;
end

endmodule