module top_module(
    input rst,
    input clk,
    input ie,
    input de,
    input [31:0] iaddr,
    input [31:0] daddr,
    input [1:0] drw,
    input [31:0] din,
    output [31:0] iout,
    output [31:0] dout,
    output reg [7:0] leds
);/* by spec, the iout and dout signals must go hiZ when we're not using them */
    reg [31:0] idata, ddata; // Changed from wire to reg
    assign iout = idata;
    assign dout = ddata;

    /* initialize idata and ddata */
    initial begin
        idata = 32'h00000000;
        ddata = 32'h00000000;
    end

    /* all data bus activity is negative edge triggered */
    always @(negedge clk) begin
        /* handle data write */
        if (drw[0] && de && !rst) begin
            leds <= din[7:0];
            $display("MOD_LEDS: %x", din[7:0]);
        end
        /* handle reset */
        else if (rst) begin
            leds <= 8'hff;
        end
    end

    /* handle data read */
    always @(*) begin
        if (ie && drw[1]) begin
            if (daddr == 32'h00000000) begin
                ddata = {24'h000000, leds};
            end
            else begin
                ddata = 32'h00000000;
            end
        end
        else begin
            ddata = 32'h00000000; // Add default case for ddata
        end
    end

    /* handle input read */
    always @(*) begin
        if (ie && !drw[1] && iaddr == 32'h00000000) begin
            idata = {24'h000000, leds};
        end
        else begin
            idata = 32'h00000000; // Add default case for idata
        end
    end

endmodule