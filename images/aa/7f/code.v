module register_16bit
(
    input clk,
    input rst,
    input load,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 16'd0;
    end else if (load) begin
        data_out <= data_in;
    end
end

endmodule