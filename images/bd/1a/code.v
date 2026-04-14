module shift_register(
    input           clk,
    input           rst,
    input           serial_in,
    output  reg [3:0] reg_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        reg_out <= 4'b0000;
    else
        reg_out <= {reg_out[2:0], serial_in};
end

endmodule