module sram_cell (
    input wire [3:0] data,
    input wire we,  // write enable
    input wire re,  // read enable
    output reg [3:0] q // output data
);
    reg [3:0] memory; // internal memory storage

    always @(posedge we) begin
        if (we) begin
            memory <= data; // write data to memory
        end
    end

    always @(posedge re) begin
        if (re) begin
            q <= memory; // read data from memory
        end
    end
endmodule