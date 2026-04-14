module top_module(
    input rxClk,
    input rxReset,
    input [1:0] dataIn,
    input validIn,
    output reg dataOut,
    output reg validOut
    );reg [1:0] shiftReg;
    reg [1:0] nextData;
    reg nextValid;

    always @(posedge rxClk or posedge rxReset) begin
        if(rxReset) begin
            shiftReg <= 2'b00;
            dataOut <= 1'b0;
            validOut <= 1'b0;
        end
        else begin
            if(validIn) begin
                shiftReg <= {shiftReg[0], dataIn[1]};
                nextData <= dataIn;
                nextValid <= 1'b1;
            end
            else begin
                nextData <= nextData;
                nextValid <= 1'b0;
            end
            dataOut <= shiftReg[1];
            validOut <= shiftReg[0];
        end
    end

endmodule