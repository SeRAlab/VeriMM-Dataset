module shift_register_8bit(
    input clk,
    input rst,
    input load,
    input shift,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 8'b00000000;
    end else if (load) begin
        data_out <= data_in;
    end else if (shift) begin
        data_out <= data_out << 1;
    end
end

endmodule