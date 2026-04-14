module shift_register_8bit(
    input wire clk,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
    );

always @(posedge clk) begin
    if (load)
        data_out <= data_in;
    else
        data_out <= data_out >> 1;
end

endmodule