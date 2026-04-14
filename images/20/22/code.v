module PIPO_shift_register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift,
    input wire dir, // 0 for right, 1 for left
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            if (dir) begin
                data_out <= {data_out[6:0], 1'b0}; // Shift left
            end else begin
                data_out <= {1'b0, data_out[7:1]}; // Shift right
            end
        end
    end
endmodule