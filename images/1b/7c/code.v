module md5_processor (
    input clk,
    input reset,
    input [31:0] data_in,
    output reg [31:0] hash_out
);

    reg [31:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 32'h0;
            hash_out <= 32'h0;
        end else begin
            state <= state ^ data_in; // Example operation: XOR
            hash_out <= state + data_in; // Example operation: addition
        end
    end
endmodule