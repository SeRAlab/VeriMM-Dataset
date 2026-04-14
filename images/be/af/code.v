module top_module(
    input clk,
    input rst_n,
    input [255:0] p_mosi,
    input p_valid,
    output sha_init,
    output sha_next,
    output sha_mode,
    output [511:0] sha_block
);reg [1:0] pValidPrev = 2'b11;
    reg [511:0] sha_block_reg;
    reg sha_init_reg;
    reg sha_next_reg;

    assign sha_init = sha_init_reg;
    assign sha_next = sha_next_reg;
    assign sha_mode = 1'b1;
    assign sha_block = sha_block_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pValidPrev <= 2'b11;
            sha_init_reg <= 1'b0;
            sha_next_reg <= 1'b0;
            sha_block_reg <= {256'h0, 1'b1, 255'h80};
        end
        else begin
            pValidPrev[1] <= pValidPrev[0];
            pValidPrev[0] <= p_valid;

            if (p_valid && !pValidPrev[1]) begin
                sha_init_reg <= 1'b1;
            end
            else begin
                sha_init_reg <= 1'b0;
            end

            if (sha_next_reg) begin
                sha_next_reg <= 1'b0;
            end
            else if (sha_block_reg[511] && !sha_next_reg) begin
                sha_next_reg <= 1'b1;
            end

            sha_block_reg <= {p_mosi, 1'b1, 255'h80};
        end
    end

endmodule