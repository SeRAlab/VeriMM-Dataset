module top_module(
    input  [2:0] AddrA,
    input  [2:0] AddrB,
    input  [2:0] AddrC,
    input  [7:0] DIH,
    input  [7:0] DIL,
    input        clk,
    input        CEN,
    input        WEH,
    input        WEL,
    output [7:0] DOAH,
    output [7:0] DOAL,
    output [7:0] DOBH,
    output [7:0] DOBL,
    output [7:0] DOCH,
    output [7:0] DOCL
);reg [7:0] RegsH [0:7];
    reg [7:0] RegsL [0:7];

    always @(posedge clk) begin
        if (CEN) begin
            if (WEH) RegsH[AddrA] <= DIH;
            if (WEL) RegsL[AddrA] <= DIL;
        end
    end

    assign DOAH = RegsH[AddrA];
    assign DOAL = RegsL[AddrA];
    assign DOBH = RegsH[AddrB];
    assign DOBL = RegsL[AddrB];
    assign DOCH = RegsH[AddrC];
    assign DOCL = RegsL[AddrC];

endmodule