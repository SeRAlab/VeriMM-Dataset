module register_32bit
(
    input clk,
    input rst_n,
    input en,
    input [31:0] data_in,
    output reg [31:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 32'd0;
    end else if (en) begin
        data_out <= data_in;
    end
end

endmodule