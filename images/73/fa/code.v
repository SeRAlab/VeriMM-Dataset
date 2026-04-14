module top_module(
    input Extsel,
    input [15:0]Imme,
    output reg[31:0] ExtendOut
    );always@(Extsel)
    begin
        if(Extsel==0)
        begin
            ExtendOut={16'b0,Imme[15:0]};
        end
        
        else if(Extsel==1)
        begin
            ExtendOut={{16{Imme[15]}},Imme[15:0]};
        end
    end
endmodule