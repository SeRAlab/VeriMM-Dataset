module top_module(
    input clk,
    input reset,
    output reg [31:0] rand_num
);reg [31:0] lfsr;
reg [31:0] feedback;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= 32'h0;
    end else begin
        feedback[0] <= lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0];
        feedback[1] <= lfsr[0];
        feedback[2] <= lfsr[1];
        feedback[3] <= lfsr[2];
        feedback[4] <= lfsr[3];
        feedback[5] <= lfsr[4];
        feedback[6] <= lfsr[5];
        feedback[7] <= lfsr[6];
        feedback[8] <= lfsr[7];
        feedback[9] <= lfsr[8];
        feedback[10] <= lfsr[9];
        feedback[11] <= lfsr[10];
        feedback[12] <= lfsr[11];
        feedback[13] <= lfsr[12];
        feedback[14] <= lfsr[13];
        feedback[15] <= lfsr[14];
        feedback[16] <= lfsr[15];
        feedback[17] <= lfsr[16];
        feedback[18] <= lfsr[17];
        feedback[19] <= lfsr[18];
        feedback[20] <= lfsr[19];
        feedback[21] <= lfsr[20];
        feedback[22] <= lfsr[21];
        feedback[23] <= lfsr[22];
        feedback[24] <= lfsr[23];
        feedback[25] <= lfsr[24];
        feedback[26] <= lfsr[25];
        feedback[27] <= lfsr[26];
        feedback[28] <= lfsr[27];
        feedback[29] <= lfsr[28];
        feedback[30] <= lfsr[29];
        feedback[31] <= lfsr[30];

        lfsr <= {lfsr[30:0], feedback[0]};
    end
end

assign rand_num = lfsr;

endmodule