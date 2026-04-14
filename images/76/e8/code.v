module reg_8bit_sync (
    input clk,
    input rst_n,
    input load,
    input clear,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 8'b00000000;
    else if (clear)
        data_out <= 8'b00000000;
    else if (load)
        data_out <= data_in;
end

endmodule