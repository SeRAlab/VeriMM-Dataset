module PIPO_Shift_Register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0; // Clear the register
        end else if (load) begin
            data_out <= data_in; // Load data into the register
        end
    end
endmodule