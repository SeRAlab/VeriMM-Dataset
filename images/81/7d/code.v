module top_module(
    input            read_n,
                     write_n,
                     reset_n,
                     ce_n,
    inout      [7:0] data,
    output reg [7:0] leds);assign data = (~(ce_n | read_n | ~write_n)) ? ~(leds) : 8'bz;

    
    
    
    wire write_ce_n;
    assign write_ce_n = write_n | ce_n;

    
    
    
    
    
    always @(negedge reset_n, posedge write_ce_n) begin
        if (~reset_n)
            leds <= ~(8'h00);
        else
            leds <= ~(data);
    end
endmodule