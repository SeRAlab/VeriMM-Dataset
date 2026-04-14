module reg_with_load (
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
end

endmodule