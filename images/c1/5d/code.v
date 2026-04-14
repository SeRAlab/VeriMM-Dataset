module Piezo_Driver(
    input  clock,
    input  reset,
    input  [24:0] data,
    input  Write,
    output reg Ack,
    output reg Piezo
    );
    reg [23:0] count;
    reg [23:0] compare;
    reg enabled;
    always @(posedge clock) begin
        count   <= (reset | (count == compare)) ? 24'h000000 : count + 1;
        compare <= (reset) ? 24'h000000 : ((Write) ? data[23:0] : compare);
        enabled <= (reset) ? 0 : ((Write) ? data[24] : enabled);
        Piezo   <= (reset | ~enabled) ? 0 : ((count == compare) ? ~Piezo : Piezo);
        Ack     <= (reset) ? 0 : Write;
    end
endmodule