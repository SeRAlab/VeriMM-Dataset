module top_module(
    output reg [31:0] ALUResult,
    output reg Zero,
    input [31:0] A,
    input [31:0] B,
    input [2:0] control
);wire [31:0] notB, muxBout, S, andResult, orResult, SLT;

    
    wire Cout;

    
    assign notB = ~B;

    
    assign muxBout = (control[2]) ? notB : B;

    assign {Cout, S} = muxBout + A + control[2]; 

    assign andResult = A & muxBout;
    assign orResult = A | muxBout;
    assign SLT = {{31{1'b0}}, {S[31]}}; 

    always @ (control[1:0] or andResult or orResult or S or SLT or ALUResult) begin
        case(control[1:0])
            2'b00: ALUResult = andResult;
            2'b01: ALUResult = orResult;
            2'b10: ALUResult = S;
            2'b11: ALUResult = SLT;
        endcase

        if (ALUResult == 32'h00000000) begin
            Zero <= 1;
        end else begin
            Zero <= 0;
        end
    end

endmodule