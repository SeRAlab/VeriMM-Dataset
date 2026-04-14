module reg_4bit_sync_reset (
    input clk,
    input rst,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else
            q <= d;
    end
endmodule