module md5_transform (
    input wire clk,
    input wire rst,
    input wire [511:0] data_in,
    output reg [127:0] hash_out
);
    reg [127:0] state;
    reg [511:0] buffer;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 128'h0123456789abcdef0123456789abcdef; // Initial state
        end else begin
            buffer <= data_in;
            for (i = 0; i < 16; i = i + 1) begin
                state[i % 128] <= (state[i % 128] + (buffer[i*32 +: 32] ^ state[(i + 1) % 128])) % (2**32);
            end
            hash_out <= state;
        end
    end
endmodule