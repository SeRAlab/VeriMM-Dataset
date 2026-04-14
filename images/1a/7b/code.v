module flash_memory_cell (
    input wire clk,
    input wire control, // control signal: 1 for write, 0 for read
    input wire [7:0] data_in, // 8-bit input data
    output reg [7:0] data_out // 8-bit output data
);
    reg [7:0] memory; // internal memory storage

    always @(posedge clk) begin
        if (control) begin
            memory <= data_in; // write input data to memory
        end else begin
            data_out <= memory; // output current memory value
        end
    end
endmodule