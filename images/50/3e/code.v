module shift_register(
    input clk,
    input rst_n,
    input load,
    input [3:0] parallel_in,
    output reg [3:0] shift_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_out <= 4'd0;
    else if (load)
        shift_out <= parallel_in;
    else
        shift_out <= {shift_out[2:0], 1'b0};
end

endmodule