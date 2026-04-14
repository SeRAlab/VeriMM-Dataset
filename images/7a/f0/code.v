module top_module(
    input  wire read_n,
    input  wire write_n,
    input  wire reset_n,
    input  wire ce_n,
    input  wire [7:0] data,
    output reg [7:0] leds  // Change output to reg
);reg [7:0] write_data = 8'h00;

    always @(*) begin
        if (~write_n) write_data <= data;
        if (~ce_n) leds <= ~write_data;
        else leds <= 8'hFF;
    end

    assign data = (~read_n) ? write_data : 8'bz;

    always @(posedge ce_n) begin
        if (~ce_n) write_data <= 8'h00;
    end

    always @(posedge reset_n) begin
        if (~reset_n) begin
            write_data <= 8'h00;
            leds <= 8'hFF;
        end
    end

endmodule