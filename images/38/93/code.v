module simple_md5 (
    input wire clk,
    input wire rst,
    input wire [127:0] data_in,
    output reg [127:0] hash_out
);
    reg [127:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 128'h0;
            hash_out <= 128'h0;
        end else begin
            // Simple bitwise operations to create a "hash"
            state <= (state ^ data_in) + {data_in[63:0], 64'h1};
            hash_out <= {state[63:0], state[127:64]} ^ {state[127:64], state[63:0]};
        end
    end
endmodule