module shift_register(
    input data_in,
    input clk,
    input rst,
    output reg [2:0] shift_out
);

always @(posedge clk) begin
    if (rst)
        shift_out <= 3'b000;
    else
        shift_out <= {shift_out[1:0], data_in};
end

endmodule