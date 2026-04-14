module shift_register (
    input clk,
    input rst,
    input [1:0] data_in,
    input shift_en,
    output reg [1:0] reg_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_out <= 2'b00; // reset to 0
        end else if (shift_en) begin
            reg_out <= {reg_out[0], data_in[1]}; // Shift right and insert new data
        end
    end
endmodule