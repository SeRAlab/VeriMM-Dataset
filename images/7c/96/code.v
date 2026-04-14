module top_module(IDEXMemRead, IDEXRt, IFIDRs, IFIDRt, PCWrite, IFIDWrite, ctrlSetZero, IDEXRd, IDEXRegWrite, opcode, EXMEMRead, EXMEMRt, clk);input [4:0] IDEXRt, IFIDRt, IFIDRs, IDEXRd, EXMEMRt;
input IDEXMemRead, IDEXRegWrite, EXMEMRead;
input [5:0] opcode;
input clk;
output reg PCWrite, IFIDWrite, ctrlSetZero;

always @ (posedge clk) begin
    if (opcode == 6'b000100) begin
        if (IDEXMemRead && ((IDEXRt == IFIDRs) || (IDEXRt == IFIDRt))) begin
            PCWrite <= 0;
            IFIDWrite <= 0;
            ctrlSetZero <= 1;
        end
        else if (IDEXRegWrite && ((IDEXRd == IFIDRs) || (IDEXRd == IFIDRt))) begin
            PCWrite <= 0;
            IFIDWrite <= 0;
            ctrlSetZero <= 1;
        end
        else if (EXMEMRead && ((EXMEMRt == IFIDRs) || (EXMEMRt == IFIDRt))) begin
            PCWrite <= 0;
            IFIDWrite <= 0;
            ctrlSetZero <= 1;
        end
        else begin
            PCWrite <= 1;
            IFIDWrite <= 1;
            ctrlSetZero <= 0;
        end
    end
    else begin
        if (IDEXMemRead && ((IDEXRt == IFIDRs) || (IDEXRt == IFIDRt))) begin
            PCWrite <= 0;
            IFIDWrite <= 0;
            ctrlSetZero <= 1;
        end
        else if (IDEXRegWrite && ((IDEXRd == IFIDRs) || (IDEXRd == IFIDRt))) begin
            PCWrite <= 0;
            IFIDWrite <= 0;
            ctrlSetZero <= 1;
        end
        else begin
            PCWrite <= 1;
            IFIDWrite <= 1;
            ctrlSetZero <= 0;
        end
    end
end

endmodule