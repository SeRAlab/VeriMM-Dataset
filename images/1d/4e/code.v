module aes_sbox(
    input [3:0] data_in,
    output reg [3:0] data_out,
    input clk,
    input rst
);
    // S-box lookup table
    reg [3:0] sbox [0:15];
    
    initial begin
        sbox[0] = 4'hA; sbox[1] = 4'h3; sbox[2] = 4'hD; sbox[3] = 4'h0;
        sbox[4] = 4'h6; sbox[5] = 4'h9; sbox[6] = 4'h5; sbox[7] = 4'hE;
        sbox[8] = 4'hC; sbox[9] = 4'h7; sbox[10] = 4'hF; sbox[11] = 4'h2;
        sbox[12] = 4'h8; sbox[13] = 4'h1; sbox[14] = 4'hB; sbox[15] = 4'h4;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else begin
            data_out <= sbox[data_in];
        end
    end
endmodule