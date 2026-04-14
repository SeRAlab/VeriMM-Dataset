module dram_cell (
    input wire clk,
    input wire WRITE,
    input wire READ,
    input wire DIN,
    output reg DOUT
);
    reg storage;

    always @(posedge clk) begin
        if (WRITE) begin
            storage <= DIN;  // Store input data
        end
    end

    always @(posedge clk) begin
        if (READ) begin
            DOUT <= storage;  // Output stored data
        end
    end
endmodule