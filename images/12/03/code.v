module siso_shift_register (
    input clk,
    input rst,
    input load,
    input serial_in,
    output reg [4:0] parallel_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        parallel_out <= 5'b00000;
    end else if (load) begin
        parallel_out <= {parallel_out[3:0], serial_in};
    end
end

endmodule