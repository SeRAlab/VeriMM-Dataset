module top_module(
    func,
    ALUOp,
    operALU
);input           [5:0]   func;
    input           [1:0]   ALUOp;

    output reg      [2:0]   operALU;
    
    always @ *
    begin
        casex(ALUOp)
            2'b00   :   operALU = 3'b010;
            2'bx1   :   operALU = 3'b110;
            2'b1x   :   begin
                casex(func)
                    6'bxx0000   :   operALU = 3'b010;
                    6'bxx0010   :   operALU = 3'b110;
                    6'bxx0100   :   operALU = 3'b000;
                    6'bxx0101   :   operALU = 3'b001;
                    6'bxx1010   :   operALU = 3'b111;
                endcase end
        endcase
    end

endmodule