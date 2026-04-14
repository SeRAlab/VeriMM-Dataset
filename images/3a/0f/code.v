module eeprom (
    input [4:0] data_in,
    input write_enable,
    input read_enable,
    output reg [4:0] data_out
);
    reg [4:0] stored_data;

    always @(*) begin
        if (write_enable) begin
            stored_data = data_in;
        end
        if (read_enable) begin
            data_out = stored_data;
        end
    end
endmodule