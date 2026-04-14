module top_module(
    input clk,
    input reset,
    input [9:0] address,
    input write_enable,
    input [8:0] write_data,
    input read_enable,
    output reg [8:0] read_data  // Changed from wire to reg
);reg [8:0] memory [0:1023];
reg [9:0] write_address;

always @(posedge clk) begin
    if (reset) begin
        write_address <= 0;
    end else if (write_enable) begin
        memory[address] <= write_data;
        write_address <= address;
    end else if (read_enable) begin
        read_data <= memory[address];  // Assignment to read_data is now valid
    end
end

endmodule