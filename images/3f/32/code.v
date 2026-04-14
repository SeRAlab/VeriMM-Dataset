module sipo_shift_register (
    input clk,
    input rst,
    input data_in,
    output reg [4:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 5'b00000; // Reset the output
        end else begin
            data_out <= {data_out[3:0], data_in}; // Shift left and insert serial data
        end
    end
endmodule