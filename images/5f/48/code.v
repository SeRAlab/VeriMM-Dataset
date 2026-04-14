module top_module(
    input [9:0] address,
    input clock,
    input [31:0] data_in,
    input write_enable,
    output reg [31:0] data_out  // Change 'output' to 'output reg'
);reg [31:0] memory [0:1023];

    always @(posedge clock) begin
        if (write_enable) begin
            memory[address] <= data_in;
        end
        data_out <= memory[address];
    end

endmodule