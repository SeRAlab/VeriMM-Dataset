module PIPO_Shift_Register (
    input clk,
    input rst,
    input load,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 5'b00000;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[3:0], 1'b0}; // Shift left
        end
    end
endmodule