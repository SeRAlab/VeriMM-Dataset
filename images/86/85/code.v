module parity_generator (
    input clk,
    input reset,
    input [2:0] data,
    output reg parity);always @(posedge clk or posedge reset) begin
    if (reset) begin
        parity <= 1'b0;
    end else begin
        parity <= data[0] ^ data[1] ^ data[2];
    end
end
endmodule