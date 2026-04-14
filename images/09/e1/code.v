module divide_by_4 (
    input wire clk,
    input wire [1:0] data_in,
    output reg [1:0] data_out
);

always @(posedge clk) begin
    data_out <= data_in / 4;
end

endmodule