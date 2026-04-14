module voltage_supply (
    output reg VPWR,
    output reg VGND
);

    // Set VPWR to 1V
    always @* begin
        VPWR = 1;
    end

    // Set VGND to 0V
    always @* begin
        VGND = 0;
    end

endmodule