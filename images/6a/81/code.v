module fibonacci_lfsr (
    input clk,
    input areset,
    input en,
    output reg [4:0] lfsr);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            lfsr <= 5'b00001;
        end else if (en) begin
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};
        end
    end
endmodule