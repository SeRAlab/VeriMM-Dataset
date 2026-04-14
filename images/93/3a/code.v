module top_module(
    input clk,
    input reset_n,
    input [7:0] data_in,
    output reg parity_out
);reg [3:0] parity;

always @ (posedge clk) begin
    if (!reset_n) begin
        parity <= 0;
        parity_out <= 0;
    end
    else begin
        parity <= parity ^ data_in;
        parity_out <= (parity[0] ^ parity[1] ^ parity[2] ^ parity[3]);
    end
end

endmodule