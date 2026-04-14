module md5_hash (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    output reg [31:0] hash_out
);
    reg [31:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 32'h0;
            hash_out <= 32'h0;
        end else begin
            state <= state ^ (data_in + 32'h12345678); // Simple XOR with a constant
            hash_out <= {state[23:0], state[31:24]}; // Rotate left
        end
    end
endmodule