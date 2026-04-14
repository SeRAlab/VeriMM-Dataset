module shift_register_8bit(
    input wire clk,
    input wire rst,
    input wire shift,
    input wire [7:0] parallel_in,
    input wire serial_in,
    output reg [7:0] data_out
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 8'b00000000;
    end
    else if (shift) begin
        data_out <= {serial_in, data_out[7:1]};
    end
    else begin
        data_out <= parallel_in;
    end
end

endmodule