module mux4to1 (
    In0,
    In1,
    In2,
    In3,
    Sel1,
    Sel2,
    Out
);

    input In0, In1, In2, In3, Sel1, Sel2;
    output Out;

    reg Out;

    always @(*) begin
        case ({Sel1, Sel2})
            2'b00: Out = In0;
            2'b01: Out = In1;
            2'b10: Out = In2;
            2'b11: Out = In3;
        endcase
    end

endmodule