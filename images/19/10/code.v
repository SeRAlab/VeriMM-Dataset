module pipo_shift_register (
    input wire clk,
    input wire reset,
    input wire [4:0] parallel_in,
    output reg [4:0] parallel_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        parallel_out <= 5'b00000;
    end else begin
        parallel_out <= parallel_in;
    end
end

endmodule