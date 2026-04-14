module PIPO_Shift_Register (
    input wire [4:0] parallel_in,
    input wire clk,
    input wire load,
    output reg [4:0] parallel_out
);

always @(posedge clk) begin
    if (load) begin
        parallel_out <= parallel_in;
    end
end

endmodule