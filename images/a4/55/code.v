module fibonacci_lfsr (
    input clk,
    input rst,
    input en,
    output reg [7:0] lfsr);

    always @(posedge clk) begin
        if (rst) begin
            lfsr <= 8'b00000001;
        end else if (en) begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5]};
        end
    end
endmodule