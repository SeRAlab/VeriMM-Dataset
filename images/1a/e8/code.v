module sata_controller (
    input wire clk,
    input wire enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (enable)
        data_out <= data_in;
end

endmodule