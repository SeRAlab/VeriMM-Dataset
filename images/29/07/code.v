module shift_register (
    input clk,
    input rst,
    input [1:0] data_in,
    input dir, // 0 for left, 1 for right
    output reg [1:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 2'b00; // Reset output to 00
    end else begin
        if (dir) begin
            // Shift right
            data_out <= {1'b0, data_out[1]}; // Shift right and append 0
        end else begin
            // Shift left
            data_out <= {data_out[0], 1'b0}; // Shift left and append 0
        end
    end
end

endmodule