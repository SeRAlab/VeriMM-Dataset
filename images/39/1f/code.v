module sram_cell (
    input wire [3:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [3:0] data_out
);
    reg [3:0] stored_data;

    always @(posedge write_enable) begin
        if (write_enable) begin
            stored_data <= data_in;
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= stored_data;
        end
    end
endmodule