module top_module(
    input CLK, WE, RE, RST,
    input [1:0] ID,
    input [31:0] PC,
    output reg [31:0] EPC
    );reg [31:0]latched_PC;
    
    always@(posedge CLK, posedge RST)
    begin
        if(RST)       latched_PC <= 0;
        else if(WE)
        begin
            latched_PC <= PC;
            case(ID)
                2'b00: EPC <= 108;
                2'b01: EPC <= 120;
                2'b10: EPC <= 132;
                2'b11: EPC <= 144; 
                default: EPC <= 0;
            endcase
        end
        else if(RE)     EPC <= latched_PC;
        else            EPC <= PC;
    end
endmodule