module shift_reg_3bit(
    input            clk,
    input            rst,
    input            load,
    input      [2:0] data_in,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 3'b000;
    end else if (load) begin
        q <= data_in;
    end else begin
        q <= {q[1:0], 1'b0};
    end
end

endmodule