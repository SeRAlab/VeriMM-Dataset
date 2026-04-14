module PIPO_Shift_Register #(parameter N = 8) (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [N-1:0] data_in,
    output reg [N-1:0] data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0; // Clear register on reset
        end else if (load) begin
            data_out <= data_in; // Load data in parallel
        end else begin
            data_out <= {data_out[N-2:0], 1'b0}; // Shift left
        end
    end
endmodule