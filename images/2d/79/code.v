module audio_mixer (
    input [7:0] A,
    input [7:0] B,
    input sel,
    output reg [7:0] Y
);
    always @(*) begin
        if (sel == 0)
            Y = A;
        else
            Y = B;
    end
endmodule