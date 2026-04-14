module noise_suppression (
    input [4:0] in,
    output reg [4:0] out
);
    integer i;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            if (in[i] == 1) begin
                out[i] = (in[0] + in[1] + in[2] + in[3] + in[4] >= 3) ? 1 : 0;
            end else begin
                out[i] = (in[0] + in[1] + in[2] + in[3] + in[4] >= 3) ? 0 : 1;
            end
        end
    end
endmodule