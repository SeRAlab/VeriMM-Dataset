module register16 (
    input wire rst_n,
    input wire clk,
    input wire load,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 16'b0000000000000000;
    else if (load)
        data_out <= data_in;
end

endmodule