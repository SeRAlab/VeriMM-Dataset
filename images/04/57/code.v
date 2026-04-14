module PIPO_Shift_Register #(parameter WIDTH = 8) (
    input wire clk,
    input wire load,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= data_in;
    end
end

endmodule