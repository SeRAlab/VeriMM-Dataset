module top_module(
    input [15:0] addr_port1,
    input [15:0] addr_port2,
    input [15:0] data_in_port1,
    input [15:0] data_in_port2,
    input write_en_port1,
    input write_en_port2,
    output [15:0] data_out_port1,
    output [15:0] data_out_port2
);reg [15:0] ram [0:65535];

always @(posedge write_en_port1) begin
    ram[addr_port1] <= data_in_port1;
end

always @(posedge write_en_port2) begin
    ram[addr_port2] <= data_in_port2;
end

assign data_out_port1 = ram[addr_port1];
assign data_out_port2 = ram[addr_port2];

endmodule