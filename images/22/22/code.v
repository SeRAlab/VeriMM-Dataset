module sha256_transform (
    input wire clk,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    parameter CONSTANT = 8'h3A;

    always @(posedge clk) begin
        data_out <= data_in + CONSTANT;
    end
endmodule