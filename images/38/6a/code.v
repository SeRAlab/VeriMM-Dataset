module flash_memory_controller (
    input wire write_enable,
    input wire erase_enable,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    always @(*) begin
        if (erase_enable) begin
            data_out = 5'b00000;
        end else if (write_enable) begin
            data_out = data_in;
        end
    end
endmodule