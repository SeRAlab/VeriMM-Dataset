module top_module(
    input CLK,
    input RST,
    input PCEN,
    input PCSrc,
    input [31:0]inPC,
    output reg [31:0]outPC
    );reg [31:0]PC0;
    always @(posedge CLK) begin
        if(RST) begin outPC<=32'hbfc00000;PC0<=32'hbfc00000; end
        else begin
            if(PCSrc) begin PC0=outPC;outPC=inPC; end
            else if(PCEN) begin PC0=outPC;outPC=outPC+32'h4; end
            else outPC=PC0;
        end
    end
endmodule