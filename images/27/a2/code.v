module shift_register (
    input clk,
    input rst,
    input enable,
    input shift_left,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else if (enable) begin
            if (shift_left) begin
                data_out <= {data_out[2:0], data_in[0]}; // Shift left and input new bit
            end else begin
                data_out <= {data_in[3], data_out[3:1]}; // Shift right and input new bit
            end
        end
    end
endmodule