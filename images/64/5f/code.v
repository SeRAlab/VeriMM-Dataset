module shiftregister3bit (
    input clk,
    input rst,
    input serial_in,
    output reg [2:0] parallel_out
);always @(posedge clk or posedge rst) begin
    if (rst) begin
        parallel_out <= 3'b000;
    end else begin
        parallel_out <= {parallel_out[1:0], serial_in};
    end
end

endmodule