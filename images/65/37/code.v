module dual_port_memory(
    input clk,
    input we,
    input [3:0] write_address,
    input [3:0] read_address,
    input [7:0] write_data,
    output reg [7:0] read_data);reg [7:0] memory [15:0];

always @(posedge clk) begin
    if (we)
        memory[write_address] <= write_data;
    read_data <= memory[read_address];
end
endmodule