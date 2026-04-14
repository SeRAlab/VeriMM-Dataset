module deserializer (
    input clk,
    input rst,
    input valid,
    input [1:0] din,
    output reg [15:0] dout
);

reg [3:0] bit_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dout <= 0;
        bit_count <= 0;
    end else if (valid && bit_count < 8) begin
        dout <= {din, dout[15:2]};
        bit_count <= bit_count + 1;
    end
end

endmodule