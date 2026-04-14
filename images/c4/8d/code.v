module my_module (
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  B1  ,
    input  B2  ,
    output X   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);

    reg X_reg;
    wire sum1, sum2;

    assign sum1 = B1 + B2;
    assign sum2 = A2 + A3;

    always @ (A1 or A2 or A3 or B1 or B2) begin
        if (A1 == 1) begin
            X_reg <= sum1;
        end else begin
            X_reg <= sum2;
        end
    end

    assign X = X_reg;

endmodule