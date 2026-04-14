module lfsr (
    input clk,
    input reset,
    output reg [15:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 16'h1;
        else
            q <= {q[14:0], q[15] ^ q[13] ^ q[12] ^ q[10]};
    end
endmodule