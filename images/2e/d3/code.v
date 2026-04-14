module hmac(
    input clk,
    input rst,
    input [127:0] key,
    input [127:0] message,
    output reg [127:0] hmac_out
);
    reg [127:0] ipad, opad;
    reg [127:0] inner_hash, outer_hash;
    reg [1:0] state;
    
    initial begin
        ipad = 128'h36363636363636363636363636363636; // 0x36 repeated
        opad = 128'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c; // 0x5c repeated
        state = 0;
        hmac_out = 0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            hmac_out <= 0;
        end else begin
            case (state)
                0: begin
                    inner_hash <= key ^ ipad; // First step of HMAC
                    state <= 1;
                end
                1: begin
                    inner_hash <= inner_hash ^ message; // Combine with message
                    outer_hash <= key ^ opad; // Prepare for outer hash
                    state <= 2;
                end
                2: begin
                    hmac_out <= outer_hash ^ inner_hash; // Final HMAC output
                    state <= 0; // Reset state
                end
            endcase
        end
    end
endmodule