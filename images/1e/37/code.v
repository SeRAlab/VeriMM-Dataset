module PIPO_Registers (
    input wire [7:0] data_in,
    input wire clk,
    input wire reset,
    input wire load,
    output reg [7:0] data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000;
        end else if (load) begin
            data_out <= data_in;
        end
    end
endmodule