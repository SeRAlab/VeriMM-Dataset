module hmac (
    input clk,
    input rst,
    input valid,
    input [127:0] key,
    input [127:0] message,
    output reg [127:0] hmac_out
);

    // Simple hash function
    function [127:0] simple_hash;
        input [127:0] data;
        begin
            simple_hash = data ^ 32'hDEADBEEF; // Placeholder simple hash function
        end
    endfunction

    reg [127:0] inner_hash;
    reg [127:0] outer_hash;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hmac_out <= 128'b0;
        end else if (valid) begin
            // HMAC computation
            inner_hash = simple_hash(key ^ message);
            outer_hash = simple_hash(key ^ inner_hash);
            hmac_out <= outer_hash;
        end
    end
endmodule