module virtual_memory_unit (
    input clk,
    input [11:0] logical_address,
    input [19:0] base_address,
    output reg [19:0] physical_address
);
    always @(posedge clk) begin
        physical_address <= logical_address + base_address[11:0];
    end
endmodule