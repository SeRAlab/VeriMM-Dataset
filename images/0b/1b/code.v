module sram_1bit (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg storage;

    always @(posedge write_enable) begin
        storage <= data_in; // Store data on write enable
    end

    always @(posedge read_enable) begin
        data_out <= storage; // Output stored data on read enable
    end
endmodule