module simple_md5 (
    input wire clk,
    input wire reset,
    input wire [127:0] data,
    input wire start,
    output reg [31:0] hash,
    output reg ready
);
    reg [31:0] state_a, state_b, state_c, state_d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_a <= 32'h67452301;
            state_b <= 32'hEFCDAB89;
            state_c <= 32'h98BADCFE;
            state_d <= 32'h10325476;
            hash <= 32'b0;
            ready <= 1'b0;
        end else if (start) begin
            // A simplified version of MD5 hashing process
            state_a <= state_a + data[31:0];
            state_b <= state_b + data[63:32];
            state_c <= state_c ^ data[95:64];
            state_d <= state_d ^ data[127:96];

            // A simple output after processing
            hash <= state_a + state_b + state_c + state_d;
            ready <= 1'b1;
        end
    end
endmodule