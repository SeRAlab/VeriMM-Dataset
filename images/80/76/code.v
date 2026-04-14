module shift_register (
    input            clk,
    input            rst,
    input            load,
    input      [3:0] data_in,
    output reg [3:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 4'b0000;
    else if (load)
        q <= data_in;
    else
        q <= {1'b0, q[3:1]};
end

endmodule