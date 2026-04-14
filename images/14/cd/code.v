module eeprom_control (
    input [4:0] DATA_IN,
    input READ_EN,
    input WRITE_EN,
    output reg [4:0] DATA_OUT
);
    always @(*) begin
        if (WRITE_EN) begin
            DATA_OUT = DATA_IN;
        end else if (READ_EN) begin
            // Maintain current state if only reading
            DATA_OUT = DATA_OUT;
        end
    end
endmodule