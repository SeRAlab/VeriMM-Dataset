module register_8bit(
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk)
begin
    if (reset)
        data_out <= 8'b00000000; // Reset to 0
    else if (load)
        data_out <= data_in; // Load data
end

endmodule