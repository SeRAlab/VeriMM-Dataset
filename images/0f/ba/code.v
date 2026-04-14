module ofdm_symbol_generator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] symbol_out
);
    // Constant for transformation
    parameter TRANSFORM_CONST = 4'b1010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            symbol_out <= 4'b0000; // Reset output
        end else begin
            symbol_out <= data_in ^ TRANSFORM_CONST; // Generate symbol
        end
    end
endmodule