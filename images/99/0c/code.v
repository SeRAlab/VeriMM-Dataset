module shift_register_8bit (clk, reset, serial_in, parallel_out);
input clk, reset, serial_in;
output reg [7:0] parallel_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        parallel_out <= 8'b00000000;
    end else begin
        parallel_out <= {parallel_out[6:0], serial_in};
    end
end

endmodule