module top_module(
    input  A1,
    input  A2,
    input  B1,
    input  B2,
    output X
);reg X_reg;
    
    always @(*) begin
        if (A1 && A2) begin
            X_reg = B1;
        end
        else if (!A1 && A2) begin
            X_reg = B2;
        end
        else if (A1 && !A2) begin
            X_reg = B1;
        end
        else if (!A1 && !A2) begin
            X_reg = B2;
        end
    end
    
    assign X = X_reg;

endmodule