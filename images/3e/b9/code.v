module sha256_simple (
    input wire clk,
    input wire reset,
    input wire [63:0] data_in,
    output reg [31:0] hash_out
);
    reg [31:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 32'h0;
            hash_out <= 32'h0;
        end else begin
            state <= state ^ (data_in[31:0] + data_in[63:32]);
            hash_out <= state;
        end
    end
endmodule