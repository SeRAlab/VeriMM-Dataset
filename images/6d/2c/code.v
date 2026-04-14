module top_module(
    input clk,
    input rst,
    input ena,
    input [3:0] gray,
    output reg [3:0] binary
);always @(posedge clk) begin
        if (rst) begin
            binary <= 4'b0000;
        end else if (ena) begin
            binary[3] <= gray[3];
            binary[2] <= binary[3] ^ gray[2];
            binary[1] <= binary[2] ^ gray[1];
            binary[0] <= binary[1] ^ gray[0];
        end
    end

endmodule