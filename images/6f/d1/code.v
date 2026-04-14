module left_shift_register (
    input wire rst_n,
    input wire clk,
    input wire load,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);

always @(posedge clk) begin
    if (!rst_n)
        data_out <= 5'b00000;
    else if (load)
        data_out <= data_in;
    else
        data_out <= data_out << 1;
end

endmodule