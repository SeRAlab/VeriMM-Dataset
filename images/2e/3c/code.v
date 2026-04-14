module dram_cell (
    input wire [3:0] data_in,
    input wire read,
    input wire write,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(*) begin
        if (write) begin
            storage <= data_in; // Store data
        end
    end

    always @(posedge read) begin
        data_out <= storage; // Read data
    end
endmodule