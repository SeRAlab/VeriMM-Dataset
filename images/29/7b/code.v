module shift_register (
    input clk,
    input rst,
    input shift_left,
    input shift_right,
    input load,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 16'b0; // Asynchronous reset
        end else if (load) begin
            data_out <= data_in; // Load data
        end else if (shift_left) begin
            data_out <= {data_out[14:0], 1'b0}; // Shift left
        end else if (shift_right) begin
            data_out <= {1'b0, data_out[15:1]}; // Shift right
        end
    end
endmodule