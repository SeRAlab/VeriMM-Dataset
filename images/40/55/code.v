module dram_cell (
    input clk,
    input write_en,
    input read_en,
    input [15:0] din,
    output reg [15:0] dout
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write_en) begin
            memory <= din; // write data to memory
        end
        if (read_en) begin
            dout <= memory; // output data from memory
        end
    end

    initial begin
        memory = 16'b0; // initialize memory to zero
    end
endmodule