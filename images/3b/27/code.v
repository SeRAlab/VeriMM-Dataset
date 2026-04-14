module decoder_4to16 (
    input [3:0] A,
    input EN,
    output reg [15:0] Y
);
    always @(*) begin
        if (EN) begin
            Y = 16'b0000000000000000; // default to all 0
            Y[A] = 1'b1; // set output corresponding to input
        end else begin
            Y = 16'b0000000000000000; // all outputs low when EN is low
        end
    end
endmodule