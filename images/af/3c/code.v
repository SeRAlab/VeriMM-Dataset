module shift_register_8bit (
    input clk,
    input rst,
    input serial_in,
    output reg [7:0] parallel_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        parallel_out <= 8'b0;
    end else begin
        parallel_out <= {parallel_out[6:0], serial_in};
    end
end

endmodule