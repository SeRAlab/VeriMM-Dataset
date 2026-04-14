module top_module(
    input [7:0] in,
    output reg [2:0] pos
);// Binary-to-Gray code converter
    wire [7:0] gray_in;
    assign gray_in[0] = in[0];
    assign gray_in[1] = in[0] ^ in[1];
    assign gray_in[2] = in[1] ^ in[2];
    assign gray_in[3] = in[2] ^ in[3];
    assign gray_in[4] = in[3] ^ in[4];
    assign gray_in[5] = in[4] ^ in[5];
    assign gray_in[6] = in[5] ^ in[6];
    assign gray_in[7] = in[6] ^ in[7];

    // Gray-to-binary code converter
    wire [7:0] gray_out;
    assign gray_out[7] = gray_in[7];
    assign gray_out[6] = gray_in[7] ^ gray_in[6];
    assign gray_out[5] = gray_in[6] ^ gray_in[5];
    assign gray_out[4] = gray_in[5] ^ gray_in[4];
    assign gray_out[3] = gray_in[4] ^ gray_in[3];
    assign gray_out[2] = gray_in[3] ^ gray_in[2];
    assign gray_out[1] = gray_in[2] ^ gray_in[1];
    assign gray_out[0] = gray_in[1] ^ gray_in[0];

    // Priority encoder
    always @* begin
        if (in == 0) begin
            pos = 0;
        end else if (gray_out[7] == 1) begin
            pos = 7;
        end else if (gray_out[6] == 1) begin
            pos = 6;
        end else if (gray_out[5] == 1) begin
            pos = 5;
        end else if (gray_out[4] == 1) begin
            pos = 4;
        end else if (gray_out[3] == 1) begin
            pos = 3;
        end else if (gray_out[2] == 1) begin
            pos = 2;
        end else if (gray_out[1] == 1) begin
            pos = 1;
        end else if (gray_out[0] == 1) begin
            pos = 0;
        end
    end

endmodule