module top_module(input [7:0] validdata, output reg wZa, wZb, wCa, wCb, wNa, wNb, output reg [15:0] wInstruction);always @ (*)
begin
    case (validdata)
        8'd8: begin
            wZa = 0;
            wZb = 0;
            wCa = 1;
            wCb = 0;
            wNa = 0;
            wNb = 0;
            wInstruction = 15'd0;
        end
        8'd16: begin
            wCa = 1;
            wCb = 0;
            wNa = 0;
            wNb = 0;
            if (wZa == 0 && wZb == 0)
            begin
                wZa = 0;
                wZb = 1;
                wInstruction = 15'd0;
            end
        end
        8'd32: begin
            wCa = 1;
            wCb = 1;
            wNa = 1;
            wNb = 0;
            if (wZa == 0 && wZb == 0)
            begin
                wZa = 1;
                wZb = 0;
                wInstruction = 15'd0;
            end
        end
        8'd64: begin
            wCa = 1;
            wCb = 1;
            wNa = 1;
            wNb = 0;
            if (wZa == 0 && wZb == 1)
            begin
                wZa = 0;
                wZb = 0;
                wInstruction = 15'd0;
            end
        end
    endcase
end
endmodule