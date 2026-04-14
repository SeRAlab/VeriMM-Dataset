module top_module(
    input VPWR,
    input VGND
);reg [31:0] voltage = 0; // initialize voltage to 0

    always @(*) begin
        if (VPWR && !VGND) begin // charge up to VPWR
            voltage = voltage + 1;
        end else if (!VPWR && VGND) begin // discharge down to VGND
            voltage = voltage - 1;
        end
    end

endmodule