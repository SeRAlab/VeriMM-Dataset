module PIPO_Shift_Register #(parameter WIDTH = 8) (
    input wire clk,
    input wire load,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= {data_out[WIDTH-2:0], 1'b0}; // Shift left and fill least significant bit with 0
    end
end

endmodule