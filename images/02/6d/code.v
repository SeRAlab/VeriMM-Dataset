module PIPO_Shift_Register (
    input clk,
    input reset,
    input load,
    input [4:0] data_in,
    input shift,
    output reg [4:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 5'b00000;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= {data_out[3:0], 1'b0}; // Shift left
        end
    end
endmodule