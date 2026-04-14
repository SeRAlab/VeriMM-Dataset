module shift_register_16bit(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 16'b0000000000000000;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= data_out >> 1;
        end
    end
endmodule