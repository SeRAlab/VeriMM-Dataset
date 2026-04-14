module my_mac(
    input clk,
    input reset,
    input ce,
    input [31:0] din0,
    input [31:0] din1,
    output reg [31:0] dout
);

always @(posedge clk) begin
    if (reset) begin
        dout <= 0;
    end else if (ce) begin
        dout <= dout + din0 * din1;
    end
end

endmodule