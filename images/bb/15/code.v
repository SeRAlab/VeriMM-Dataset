module lfsr(
    input clk,
    input rst,
    input en,
    output reg [5:0] lfsr
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 6'b000001;
        else if (en)
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[3]};
    end

endmodule