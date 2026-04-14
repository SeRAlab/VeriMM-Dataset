module md5_simple (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    output reg [31:0] hash_out
);
    reg [31:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 32'h0;
            hash_out <= 32'h0;
        end else begin
            // A simplified transformation for hashing
            state <= state + data_in;
            hash_out <= (state & data_in) ^ (~state | data_in);
        end
    end
endmodule