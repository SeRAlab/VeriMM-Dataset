module shift_reg_16bit (
    input clk,
    input rst_n,
    input ser_in,
    output reg [15:0] par_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        par_out <= 16'b0;
    else
        par_out <= {par_out[14:0], ser_in};
end

endmodule