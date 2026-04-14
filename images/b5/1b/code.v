module galois_lfsr (
    input clk,
    input rst,
    input en,
    output reg [6:0] lfsr);

    always @(posedge clk) begin
        if (rst) begin
            lfsr <= 7'b0000001;
        end else if (en) begin
            lfsr <= {lfsr[5:0], lfsr[6] ^ lfsr[5]};
        end
    end
endmodule