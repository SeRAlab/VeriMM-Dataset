module shift_register_8bit(clk, rst, serial_in, parallel_out);
input clk, rst, serial_in;
output reg [7:0] parallel_out;

always @(posedge clk or posedge rst) begin
    if (rst)
        parallel_out <= 8'b0;
    else
        parallel_out <= {parallel_out[6:0], serial_in};
end

endmodule