module d_ff_ar_en_posedge (input D, C, E, R, output reg Q);
    always @(posedge C) begin
        if (R) begin
            Q <= 1'b0;
        end else if (E) begin
            Q <= D;
        end
    end
endmodule