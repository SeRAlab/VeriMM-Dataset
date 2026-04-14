module parallel_load_register_12bit
(
    input clk,
    input rst,
    input load,
    input [11:0] data_in,
    output reg [11:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 12'b000000000000;
    end
    else if (load) begin
        q <= data_in;
    end
end

endmodule