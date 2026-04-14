module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input EN,
    output Y
);reg Y_reg;

always @(*) begin
    if (EN && A1 && A2 && A3 && A4) begin
        Y_reg = 1;
    end
    else begin
        Y_reg = 0;
    end
end

assign Y = Y_reg;

endmodule