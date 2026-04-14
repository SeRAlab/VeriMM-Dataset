module top_module(
input wire Clk,
input wire CEN,
input wire WEH,
input wire WEL,
input wire [2:0] AddrA,
input wire [2:0] AddrB,
input wire [2:0] AddrC,
input wire [7:0] DIH,
input wire [7:0] DIL,
output wire [7:0] DOAH,
output wire [7:0] DOAL,
output wire [7:0] DOBH,
output wire [7:0] DOBL,
output wire [7:0] DOCH,
output wire [7:0] DOCL
);reg [7:0] RegsH [0:7];
reg [7:0] RegsL [0:7];

always@(posedge Clk) begin
    if (CEN == 1) begin
        if (WEH == 1) begin
            RegsH[AddrA] <= DIH;
        end
        if (WEL == 1) begin
            RegsH[AddrA] <= DIL;
        end
    end
end

assign DOAH = RegsH[AddrA];
assign DOAL = RegsH[AddrA];
assign DOBH = RegsH[AddrB];
assign DOBL = RegsH[AddrB];
assign DOCH = RegsH[AddrC];
assign DOCL = RegsH[AddrC];

endmodule