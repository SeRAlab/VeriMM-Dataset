module shift_register_16bit
(
    input clk,
    input rst,
    input data_in,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 16'b0000000000000000;
    end
    else begin
        q <= {q[14:0], data_in};
    end
end

endmodule