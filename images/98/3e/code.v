module top_module(
    input CLK,
    input [1:0] PCSrc,
    input [31:0] CurPC,
    input [31:0] ExtOut,
    input [25:0] JumpAddr,
    output reg [31:0] newPC
    );wire [31:0] PC4=CurPC+4;
    always@(*) begin
        case(PCSrc)
            2'b00:newPC=PC4;
            2'b01:newPC=PC4+(ExtOut<<2);
            2'b10:newPC={PC4[31:28],JumpAddr[25:0],2'b00};
        endcase
    end
endmodule