module SISO_Shift_Register (
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg [3:0] data_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000; // Reset the register
        end else begin
            data_out <= {data_out[2:0], data_in}; // Shift left and input new data
        end
    end
endmodule