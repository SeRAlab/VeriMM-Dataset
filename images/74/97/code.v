module shift_register (
    input clk,
    input reset_n,
    input serial_in,
    output reg [3:0] reg_out);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        reg_out <= 4'b0000;
    else
        reg_out <= {serial_in, reg_out[3:1]};
end

endmodule