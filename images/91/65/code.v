module shift_register(
    input clk,
    input clr,
    input load,
    input shift,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (clr)
        data_out <= 8'b0;
    else if (load)
        data_out <= data_in;
    else if (shift)
        data_out <= data_out << 1;
end

endmodule